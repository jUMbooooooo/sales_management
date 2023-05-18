import 'package:flutter/material.dart';

class AddInventory extends StatelessWidget {
  const AddInventory({super.key});

  @override
  Widget build(BuildContext context) {
    // return MaterialApp
    // 新しい画面を作成するたびに新しいMaterialAppを作成するのは適切ではない
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text("在庫追加"),
        backgroundColor: Color(0xFF222831),
      ),
      body: TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: '',
        ),
      ),
    );
  }
}
