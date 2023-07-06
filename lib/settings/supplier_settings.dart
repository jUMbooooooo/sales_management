// ignore_for_file: library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SupplierSettingsPage extends StatefulWidget {
  final String userId;

  const SupplierSettingsPage(this.userId, {super.key});

  @override
  _SupplierSettingsPageState createState() => _SupplierSettingsPageState();
}

class _SupplierSettingsPageState extends State<SupplierSettingsPage> {
  final TextEditingController _supplierController = TextEditingController();
  final TextEditingController _supplierInfoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var currentUser = FirebaseAuth.instance.currentUser!;

    var currentUserId = currentUser.uid;

    final userReference =
        FirebaseFirestore.instance.collection('users').doc(currentUserId);

    // print('userId{$currentUserId}');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF222831),
        title: const Text('仕入れ先設定'),
      ),
      body: Column(
        children: <Widget>[
          TextField(
            controller: _supplierController,
            decoration: const InputDecoration(labelText: '仕入れ先名'),
          ),
          TextField(
            controller: _supplierInfoController,
            decoration: const InputDecoration(labelText: '仕入れ先情報'),
          ),
          // Add a new sales location
          ElevatedButton(
            onPressed: () {
              if (_supplierController.text.isNotEmpty &&
                  _supplierInfoController.text.isNotEmpty) {
                userReference.collection('supplier').add({
                  'supplierName': _supplierController.text,
                  'supplierInfo': _supplierInfoController.text,
                });
                _supplierController.clear();
                _supplierInfoController.clear();
              }
            },
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(const Color(0xFF222831)),
            ),
            child: const Text('仕入れ先を追加'),
          ),
          // Display the list of sales locations
          StreamBuilder<QuerySnapshot>(
            stream: userReference.collection('supplier').snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) return const Text('読み込み中...');
              return Expanded(
                child: ListView.separated(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    DocumentSnapshot document = snapshot.data!.docs[index];
                    Map<String, dynamic> data =
                        document.data() as Map<String, dynamic>;
                    return ListTile(
                      title: Text(data['supplierName']),
                      subtitle: Text(data['supplierInfo']),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          userReference
                              .collection('supplier')
                              .doc(document.id)
                              .delete();
                        },
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const Divider(
                      color: Colors.grey, // 線の色をグレーに指定
                      height: 10, // 項目間の高さを10に指定
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
