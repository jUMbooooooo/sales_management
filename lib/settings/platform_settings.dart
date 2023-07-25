import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlatformSettingsPage extends ConsumerStatefulWidget {
  final String userId;

  const PlatformSettingsPage(this.userId, {Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PlatformSettingsPageState();
}

class _PlatformSettingsPageState extends ConsumerState<PlatformSettingsPage> {
  final TextEditingController _platformController = TextEditingController();
  final TextEditingController _feeRateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser!;

    final currentUserId = currentUser.uid;

    final userReference =
        FirebaseFirestore.instance.collection('users').doc(currentUserId);

    // print('userId{$currentUserId}');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF222831),
        title: const Text('販売先設定'),
      ),
      body: Column(
        children: <Widget>[
          TextField(
            controller: _platformController,
            decoration: const InputDecoration(labelText: '販売先を追加'),
          ),
          TextField(
            controller: _feeRateController,
            decoration: const InputDecoration(labelText: '手数料率を追加'),
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
          ),
          // Add a new sales location
          ElevatedButton(
            onPressed: () {
              if (_platformController.text.isNotEmpty &&
                  _feeRateController.text.isNotEmpty) {
                double feeRate = double.parse(_feeRateController.text) /
                    100; // Parse the feeRate as a double and divide by 100 to get a percentage
                userReference.collection('sellLocation').add({
                  'locationName': _platformController.text,
                  'feeRate': feeRate,
                });
                _platformController.clear();
                _feeRateController.clear();
              }
            },
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(const Color(0xFF222831)),
            ),
            child: const Text('販売先を追加'),
          ),
          // Display the list of sales locations
          StreamBuilder<QuerySnapshot>(
            stream: userReference.collection('sellLocation').snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) return const Text('読み込み中...');
              return Expanded(
                child: ListView.separated(
                  itemCount: snapshot.data!.docs.length, // アイテムの数
                  itemBuilder: (BuildContext context, int index) {
                    DocumentSnapshot document = snapshot.data!.docs[index];
                    Map<String, dynamic> data =
                        document.data() as Map<String, dynamic>;
                    return ListTile(
                      title: Text(data['locationName']),
                      subtitle: Text(
                          '手数料率: ${(data['feeRate'] * 100).toStringAsFixed(2)}%'), // 小数点以下2桁に制限
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          userReference
                              .collection('sellLocation')
                              .doc(document.id)
                              .delete();
                        },
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const Divider(
                      color: Colors.grey,
                      height: 0,
                    ); // ここで項目間に挿入するウィジェットを定義します
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
