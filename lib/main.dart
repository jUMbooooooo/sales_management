import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_management_app/firebase_options.dart';
import 'package:sales_management_app/inventory_class.dart';
import 'sign_in_page.dart';

// Firebaseの初期化
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.android,
  );
  runApp(ProviderScope(child: MyApp()));
}

// MyAppをビルド
// SignInPageを表示させている
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
      home: const SignInPage(),
    );
  }
}

final currentUser = FirebaseAuth.instance.currentUser!;

final currentUserId = currentUser.uid;
// final posterName = user.displayName!;
// final posterImageUrl = user.photoURL!;

final userReference =
    FirebaseFirestore.instance.collection('users').doc(currentUserId);

//このwithConverterではinventoriesというコレクションにInventoryが入ることが想定されている
//しかし、Firebaseを確認するとinventoryというコレクションにデータが入っている
//原因は、add_inventory.dartにあるonpressedの中身
//onpressedの中身でfirestoreDatabaseに飛ばすときにinventoryというクラスで送っている
// withCOnverterを使って、Firestoreへの接続の窓口をコレクションにしている

// なぜユーザーのサブコレクションがうまくいったのか。

final inventoriesReference = FirebaseFirestore.instance
    .collection('inventories')
    .withConverter<Inventory>(fromFirestore: ((snapshot, _) {
  return Inventory.fromFirestore(snapshot);
}), toFirestore: ((value, _) {
  return value.toMap();
}));


// サブコレクション実装のコード

// final inventoriesReference = userReference
//     .collection('inventories')
//     .withConverter<Inventory>(fromFirestore: ((snapshot, _) {
//   return Inventory.fromFirestore(snapshot);
// }), toFirestore: ((value, _) {
//   return value.toMap();
// }));
