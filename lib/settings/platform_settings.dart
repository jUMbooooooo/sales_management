import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:sales_management_app/main.dart';

class PlatformSettingsPage extends StatefulWidget {
  final String userId;

  PlatformSettingsPage(this.userId);

  @override
  _PlatformSettingsPageState createState() => _PlatformSettingsPageState();
}

class _PlatformSettingsPageState extends State<PlatformSettingsPage> {
  final TextEditingController _platformController = TextEditingController();

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
        title: Text('販売先設定'),
      ),
      body: Column(
        children: <Widget>[
          TextField(
            controller: _platformController,
            decoration: InputDecoration(labelText: '販売先を追加'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_platformController.text.isNotEmpty) {
                // userReference.update({
                //   'platformNames': FieldValue.arrayUnion([_platformController.text])
                // });
                //updateの場合、ドキュメントが存在しないとエラーがでる。（ドキュメントは存在しているが、フィールドは確かに存在していなかった。）
                //setにすることで、ドキュメントが存在しない場合は自動生成してくれるようになる。
                userReference.set({
                  'platformNames':
                      FieldValue.arrayUnion([_platformController.text])
                }, SetOptions(merge: true));

                _platformController.clear();
              }
            },
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(const Color(0xFF222831)),
            ),
            child: Text('販売先を追加'),
          ),
          StreamBuilder<DocumentSnapshot>(
            stream: userReference.snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (!snapshot.hasData) return const Text('読み込み中...');
              final DocumentSnapshot document = snapshot.data!;
              final Map<String, dynamic>? documentData =
                  document.data() as Map<String, dynamic>?;
              final List<String> platformNames = documentData != null &&
                      documentData.containsKey('platformNames')
                  ? List<String>.from(documentData['platformNames'])
                  : [];

              return Expanded(
                child: ListView.separated(
                    itemCount: platformNames.length,
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(color: Colors.blueGrey),
                    itemBuilder: (BuildContext context, int index) {
                      String platformName = platformNames[index];
                      return ListTile(
                        title: Text(platformName),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            userReference.update({
                              'platformNames':
                                  FieldValue.arrayRemove([platformName])
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
