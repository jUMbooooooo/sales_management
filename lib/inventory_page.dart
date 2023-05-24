import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sales_management_app/firebase_options.dart';
import 'add_inventory.dart';
import 'sign_in_page.dart';
import 'main.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("在庫管理アプリ"),
          backgroundColor: Color(0xFF222831),
        ),
        body: ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            return Row(
              children: [
                Image.network(
                  products[index]['imageUrl']!,
                  height: 100.0,
                  width: 100.0,
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        products[index]['controlNumber']!,
                        style: TextStyle(
                          color: Colors.blue[300],
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        products[index]['productName']!,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        products[index]['brandName']!,
                        style: TextStyle(
                          color: Colors.blue[300],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            );
          },
        ),
        floatingActionButton: Builder(builder: (context) {
          return FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddInventory(),
                ),
              );
            },
            child: Icon(Icons.add),
            backgroundColor: Color(0xFF222831),
          );
        }),
      ),
    );
  }
}
