import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../inventory_class.dart';
// import 'package:sales_management_app/main.dart';

/// 全投稿データをstreamで提供するProvider
// final inventoriesProvider = StreamProvider((ref) {
//   return inventoriesReference.snapshots();
// });

final userIdProvider =
    StateProvider((ref) => FirebaseAuth.instance.currentUser!.uid);

/// 全投稿データをstreamで提供するProvider
final inventoriesProvider = StreamProvider<List<Inventory>>((ref) {
  final userId = ref.watch(userIdProvider); // ユーザーIDの取得
  return FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('inventories')
      .snapshots()
      .map((query) =>
          query.docs.map((doc) => Inventory.fromFirestore(doc)).toList());
});
