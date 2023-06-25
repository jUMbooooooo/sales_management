import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BrandsSettingsPage extends StatefulWidget {
  final String userId;

  BrandsSettingsPage(this.userId);

  @override
  _BrandsSettingsPageState createState() => _BrandsSettingsPageState();
}

class _BrandsSettingsPageState extends State<BrandsSettingsPage> {
  final TextEditingController _brandController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    CollectionReference brands = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .collection('brands');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF222831),
        title: Text('ブランド設定'),
      ),
      body: Column(
        children: <Widget>[
          TextField(
            controller: _brandController,
            decoration: InputDecoration(labelText: 'ブランド名を追加'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_brandController.text.isNotEmpty) {
                brands.add({'name': _brandController.text});
                _brandController.clear();
              }
            },
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(const Color(0xFF222831)),
            ),
            child: Text('ブランドを追加'),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: brands.orderBy('name').snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) return const Text('読み込み中...');
                final List<DocumentSnapshot> documents = snapshot.data!.docs;

                return ListView(
                  children: documents.map((DocumentSnapshot document) {
                    return ListTile(
                      title: Text(document['name']),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          document.reference.delete();
                        },
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
