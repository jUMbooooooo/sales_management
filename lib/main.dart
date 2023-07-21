import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_management_app/firebase_options.dart';
import 'sign_in_page.dart';
import 'dart:io';

// Firebaseの初期化
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Platform specific initialization
  if (Platform.isAndroid) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.android,
    );
  } else if (Platform.isIOS) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.ios,
    );
  }

  runApp(const ProviderScope(child: MyApp()));
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

// var userReference =
//     FirebaseFirestore.instance.collection('users').doc(currentUserId);

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
