import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_management_app/provider/inventory_provider.dart';

class BrandsSettingPage extends ConsumerStatefulWidget {
  final String userId;

  const BrandsSettingPage(this.userId, {Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BrandsSettingPageState();
}

class _BrandsSettingPageState extends ConsumerState<BrandsSettingPage> {
  final TextEditingController _brandController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final userReference = ref.watch(userReferenceProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF222831),
        title: const Text('ブランド設定'),
      ),
      body: Column(
        children: <Widget>[
          TextField(
            controller: _brandController,
            decoration: const InputDecoration(labelText: 'ブランド名を追加'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_brandController.text.isNotEmpty) {
                // userReference.update({
                //   'brandNames': FieldValue.arrayUnion([_brandController.text])
                // });
                //updateの場合、ドキュメントが存在しないとエラーがでる。（ドキュメントは存在しているが、フィールドは確かに存在していなかった。）
                //setにすることで、ドキュメントが存在しない場合は自動生成してくれるようになる。
                userReference!.set({
                  'brandNames': FieldValue.arrayUnion([_brandController.text])
                }, SetOptions(merge: true));

                _brandController.clear();
              }
            },
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(const Color(0xFF222831)),
            ),
            child: const Text('ブランドを追加'),
          ),
          StreamBuilder<DocumentSnapshot>(
            stream: userReference!.snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (!snapshot.hasData) return const Text('読み込み中...');
              final DocumentSnapshot document = snapshot.data!;
              final Map<String, dynamic>? documentData =
                  document.data() as Map<String, dynamic>?;
              final List<String> brandNames =
                  documentData != null && documentData.containsKey('brandNames')
                      ? List<String>.from(documentData['brandNames'])
                      : [];

              return Expanded(
                child: ListView.separated(
                    itemCount: brandNames.length,
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(
                          color: Colors.blueGrey,
                          height: 0,
                        ),
                    itemBuilder: (BuildContext context, int index) {
                      String brandName = brandNames[index];
                      return ListTile(
                        title: Text(brandName),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            userReference.update({
                              'brandNames': FieldValue.arrayRemove([brandName])
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
