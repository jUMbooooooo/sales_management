import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../inventory_class.dart';
// import 'package:sales_management_app/main.dart';

// リアルタイムでユーザー情報を監視するProviderが理想
final userProvider = StreamProvider((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

// userProviderに依存
final userIdProvider = Provider.autoDispose((ref) {
  return ref.watch(userProvider).value?.uid;
});
// 何かに依存させたいときはref.watchで依存

// userIdProviderに依存
// 全投稿データをstreamで提供するProvider
// 消さないとキャッシュに残っちゃうので、autoDisposeは使うこと多い
// キャッシュしている情報を読みたい場合もある
final inventoriesProvider = StreamProvider.autoDispose<List<Inventory>>((ref) {
  final userId = ref.watch(userIdProvider); // ユーザーIDの取得
  // userIdがnullだったら空を返す
  if (userId == null) {
    return const Stream.empty();
  }
  return FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('inventories')
      .snapshots()
      .map((query) =>
          query.docs.map((doc) => Inventory.fromFirestore(doc)).toList());
});
