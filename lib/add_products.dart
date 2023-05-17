import 'package:flutter/material.dart';

class addInventory extends StatelessWidget {
  const addInventory({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("在庫追加"),
        ),
      ),
    );
  }
}
