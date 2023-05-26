import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sales_management_app/firebase_options.dart';
import 'package:sales_management_app/inventory_class.dart';
import 'sign_in_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.android,
  );
  runApp(const MyApp());
}

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

final inventoriesReference = FirebaseFirestore.instance
    .collection('inventories')
    .withConverter<Inventory>(fromFirestore: ((snapshot, _) {
  return Inventory.fromFirestore(snapshot);
}), toFirestore: ((value, _) {
  return value.toMap();
}));
