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
//   final inventoriesReference =
//       ref.watch(inventoriesReferenceProvider); // ユーザーIDの取得
//   // userIdがnullだったら空を返す
//   if (inventoriesReference == null) {
//     return const Stream.empty();
//   }
//   return inventoriesReference.snapshots().map((query) {
//     return query.docs.map((doc) {
//       return Inventory.fromFirestore(doc);
//     }).toList();
//   });
// });

/// 全投稿データをstreamで提供するProvider
final inventoriesProvider = StreamProvider.autoDispose<List<Inventory>>((ref) {
  final userReference = ref.watch(userReferenceProvider);

  if (userReference != null) {
    return userReference.collection('inventories').snapshots().map((query) =>
        query.docs.map((doc) => Inventory.fromFirestore(doc)).toList());
  }
  return const Stream.empty();
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