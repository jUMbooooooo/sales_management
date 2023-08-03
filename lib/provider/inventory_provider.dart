import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/inventory_class.dart';
// import 'package:sales_management_app/main.dart';

// リアルタイムでユーザー情報を監視するProviderが理想
// userProviderはUser?型のStreamProvider
final userProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

// userProviderに依存
// userIdProviderはString?型のAutoDisposeProvider
final userIdProvider = Provider.autoDispose((ref) {
  return ref.watch(userProvider).value?.uid;
});
// 何かに依存させたいときはref.watchで依存

// userReferenceProviderをuserIdProviderに依存する形で定義
final userReferenceProvider = Provider.autoDispose((ref) {
  final userId = ref.watch(userIdProvider);
  if (userId != null) {
    return FirebaseFirestore.instance.collection('users').doc(userId);
  }
  return null;
});

// inventoriesReferenceProviderをuserReferenceProvidersに依存する形で定義
final inventoriesReferenceProvider = Provider.autoDispose((ref) {
  final userReference = ref.watch(userReferenceProvider);
  if (userReference != null) {
    return userReference.collection('inventories').withConverter<Inventory>(
      fromFirestore: ((snapshot, _) {
        return Inventory.fromFirestore(snapshot);
      }),
      toFirestore: ((value, _) {
        return value.toMap();
      }),
    );
  }
  return null;
});

// inventoriesReferenceProviderに依存
// 全投稿データをstreamで提供するProvider
// 単体取得を書いていない
// 消さないとキャッシュに残っちゃうので、autoDisposeは使うこと多い
// キャッシュしている情報を読みたい場合もある
// final inventoriesProvider = StreamProvider.autoDispose<List<Inventory>>((ref) {
// 全投稿データをstreamで提供するProvider
final inventoriesProvider = StreamProvider.autoDispose<List<Inventory>>((ref) {
  final userReference = ref.watch(userReferenceProvider);

  if (userReference != null) {
    return userReference.collection('inventories').snapshots().map((query) {
      return query.docs.map((doc) => Inventory.fromFirestore(doc)).toList();
    });
  }
  return const Stream.empty();
});

final brandNamesProvider =
    FutureProvider.autoDispose<List<String>>((ref) async {
  final userId = ref.watch(userIdProvider);
  if (userId == null) throw Exception('User not logged in');
  final userReference = ref.watch(userReferenceProvider);
  final docSnapshot = await userReference!.get();

  // Check if 'brandNames' field exists in the document
  if (docSnapshot.exists && docSnapshot.data()!.containsKey('brandNames')) {
    final data = docSnapshot.data()!['brandNames'];

    if (data is! List<dynamic>) throw Exception('Invalid brand names data');

    final brands = data.map((item) => item.toString()).toList();

    // Don't add default value, just return the list as is
    return List<String>.from(brands);
  } else {
    // Return an empty list if 'brandNames' field does not exist
    return [];
  }
});

final supplierNamesProvider =
    FutureProvider.autoDispose<List<String>>((ref) async {
  final userId = ref.watch(userIdProvider);
  if (userId == null) throw Exception('User not logged in');
  final userReference = ref.watch(userReferenceProvider);
  final collectionRef = userReference!.collection('supplier');

  final querySnapshot = await collectionRef.get();
  final documents = querySnapshot.docs;

  // If no documents in the collection, return an empty list
  if (documents.isEmpty) {
    return [];
  }

  List<String> supplierNames = [];
  for (var document in documents) {
    if (document.exists && document.data().containsKey('supplierName')) {
      final data = document.data()['supplierName'];
      if (data is! String) throw Exception('Invalid supplier name data');
      supplierNames.add(data);
    }
  }

  // If no valid supplier names found, return an empty list
  if (supplierNames.isEmpty) {
    return [];
  }

  return List<String>.from(supplierNames);
});

final locationNameProvider =
    FutureProvider.autoDispose<List<String>>((ref) async {
  final userId = ref.watch(userIdProvider);
  if (userId == null) throw Exception('User not logged in');
  final userReference = ref.watch(userReferenceProvider);
  final collectionRef = userReference!.collection('sellLocation');

  final querySnapshot = await collectionRef.get();
  final documents = querySnapshot.docs;

  // If no documents in the collection, return an empty list
  if (documents.isEmpty) {
    return [];
  }

  List<String> locationName = [];
  for (var document in documents) {
    if (document.exists && document.data().containsKey('locationName')) {
      final data = document.data()['locationName'];
      if (data is! String) throw Exception('Invalid sellLocation name data');
      locationName.add(data);
    }
  }

  // If no valid supplier names found, return an empty list
  if (locationName.isEmpty) {
    return [];
  }

  return List<String>.from(locationName);
});

// class SellLocation {
//   final double feeRate;
//   final String locationName;
//   final String id;

//   SellLocation(
//       {required this.feeRate, required this.locationName, required this.id});
// }

class SellLocation {
  final double feeRate;
  final String locationName;
  final String id;

  SellLocation(
      {required this.feeRate, required this.locationName, required this.id});

  @override
  String toString() {
    return 'SellLocation{feeRate: $feeRate, locationName: $locationName, id: $id}';
  }
}

final sellLocationsProvider =
    FutureProvider.autoDispose<List<SellLocation>>((ref) async {
  final userId = ref.watch(userIdProvider);
  if (userId == null) throw Exception('User not logged in');
  final userReference = ref.watch(userReferenceProvider);
  final collectionRef = userReference!.collection('sellLocation');

  final querySnapshot = await collectionRef.get();
  final documents = querySnapshot.docs;

  List<SellLocation> sellLocations = [];
  for (var document in documents) {
    if (document.exists &&
        document.data().containsKey('feeRate') &&
        document.data().containsKey('locationName')) {
      final data = document.data();
      final feeRate = (data['feeRate'] as num).toDouble();
      final locationName = data['locationName'] as String;

      sellLocations.add(SellLocation(
          feeRate: feeRate, locationName: locationName, id: document.id));
    }
  }

  print('sellLocations: $sellLocations'); // Add this line

  return sellLocations;
});

class SellInfo {
  final double fee;
  final double deposit;

  SellInfo({required this.fee, required this.deposit});
}

// Assume you have a Provider that returns a specific Inventory object.
final inventoryProvider =
    Provider.family<Inventory, String>((ref, inventoryId) {
  // Fetch the specific Inventory object using inventoryId.
  // You might need to adjust this part according to your Firestore structure.
  final userReference =
      ref.watch(userReferenceProvider as AlwaysAliveProviderListenable);
  if (userReference == null) throw Exception('User not logged in');

  final docSnapshot =
      userReference.collection('inventories').doc(inventoryId).get();

  if (!docSnapshot.exists) throw Exception('Inventory not found');

  return Inventory.fromFirestore(docSnapshot.data());
});

final sellInfoProvider = Provider.family<SellInfo, String>((ref, inventoryId) {
  // Fetch the specific Inventory object.
  final inventory = ref.watch(inventoryProvider(inventoryId));
  final sellLocations = ref
      .watch(sellLocationsProvider as AlwaysAliveProviderListenable)
      .data
      ?.value;

  if (sellLocations == null) throw Exception('Sell locations not loaded');

  // Match the sellLocation in the inventory with the one in sellLocations
  final location = sellLocations
      .firstWhere((loc) => loc.locationName == inventory.sellLocation);

  final feeRate = location.feeRate;
  final sellPrice = inventory.sellingPrice;

  final fee = feeRate * sellPrice;
  final deposit = sellPrice! - fee;

  return SellInfo(fee: fee, deposit: deposit);
});




// // firestoreからのやり取りは全てMap型
// // 取得するときにInventoryクラスに
// // 格納する時はInventoryクラスからMapに
// var inventoriesReference = userReference
//     .collection('inventories')
//     .withConverter<Inventory>(fromFirestore: ((snapshot, _) {
//   return Inventory.fromFirestore(snapshot);
// }), toFirestore: ((value, _) {
//   return value.toMap();
// }));



// inventoriesReferenceProviderに依存
// 全投稿データをstreamで提供するProvider
// 単体取得を書いていない
// 消さないとキャッシュに残っちゃうので、autoDisposeは使うこと多い
// キャッシュしている情報を読みたい場合もある
// final inventoriesProvider = StreamProvider.autoDispose<List<Inventory>>((ref) {
//   final inventoriesReference =
//       ref.watch(inventoriesReferenceProvider); // ユーザーIDの取得
//   // userIdがnullだったら空を返す
//   if (inventoriesReference == null) {
//     return const Stream.empty();
//   }
//   return inventoriesReference.snapshots().map((query) =>
//       query.docs.map((doc) => Inventory.fromFirestore(doc)).toList());
// });

// FirebaseFirestoreProviderも作ると便利
// テストコードを使うときに必要