import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:sales_management_app/main.dart';

class SuppliersSettingsPage extends StatefulWidget {
  final String userId;

  SuppliersSettingsPage(this.userId);

  @override
  _SuppliersSettingsPageState createState() => _SuppliersSettingsPageState();
}

class _SuppliersSettingsPageState extends State<SuppliersSettingsPage> {
  final TextEditingController _supplierController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser!;

    final currentUserId = currentUser.uid;

    final userReference =
        FirebaseFirestore.instance.collection('users').doc(currentUserId);

    print('userId{$currentUserId}');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF222831),
        title: Text('ブランド設定'),
      ),
      body: Column(
        children: <Widget>[
          TextField(
            controller: _supplierController,
            decoration: InputDecoration(labelText: 'ブランド名を追加'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_supplierController.text.isNotEmpty) {
                // userReference.update({
                //   'supplierNames': FieldValue.arrayUnion([_supplierController.text])
                // });
                //updateの場合、ドキュメントが存在しないとエラーがでる。（ドキュメントは存在しているが、フィールドは確かに存在していなかった。）
                //setにすることで、ドキュメントが存在しない場合は自動生成してくれるようになる。
                userReference.set({
                  'supplierNames':
                      FieldValue.arrayUnion([_supplierController.text])
                }, SetOptions(merge: true));

                _supplierController.clear();
              }
            },
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(const Color(0xFF222831)),
            ),
            child: Text('仕入先を追加'),
          ),
          StreamBuilder<DocumentSnapshot>(
            stream: userReference.snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (!snapshot.hasData) return const Text('読み込み中...');
              final DocumentSnapshot document = snapshot.data!;
              final Map<String, dynamic>? documentData =
                  document.data() as Map<String, dynamic>?;
              final List<String> supplierNames = documentData != null &&
                      documentData.containsKey('supplierNames')
                  ? List<String>.from(documentData['supplierNames'])
                  : [];

              return Expanded(
                child: ListView.separated(
                    itemCount: supplierNames.length,
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(color: Colors.blueGrey),
                    itemBuilder: (BuildContext context, int index) {
                      String supplierName = supplierNames[index];
                      return ListTile(
                        title: Text(supplierName),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            userReference.update({
                              'supplierNames':
                                  FieldValue.arrayRemove([supplierName])
                            });
                          },
                        ),
                      );
                    }),
              );
            },
          ),
        ],
      ),
    );
  }
}
