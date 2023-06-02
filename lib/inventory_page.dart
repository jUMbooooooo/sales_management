import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sales_management_app/inventory_class.dart';
import 'package:sales_management_app/main.dart';
import 'add_inventory.dart';

// List<Map<String, String>> products = [
//   {
//     'controlNumber': '12345678', //管理番号
//     'productName': '【超美品】ルイヴィトン ブラスレ・LV チェーンリンクス ブレスレット シルバー', //商品名
//     'brandName': 'LOUIS VUITTON', //ブランド名
//     'imageUrl':
//         'https://jp.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-%E3%82%A2%E3%83%AB%E3%83%9E-bb-%E3%83%A2%E3%83%8E%E3%82%B0%E3%83%A9%E3%83%A0-%E3%83%90%E3%83%83%E3%82%B0--M53152_PM2_Front%20view.png?wid=1080&hei=1080' //画像URL
//   },
//   {
//     'controlNumber': '12345678', //管理番号
//     'productName': '【超美品】ルイヴィトン ブラスレ・LV チェーンリンクス ブレスレット シルバー', //商品名
//     'brandName': 'LOUIS VUITTON', //ブランド名
//     'imageUrl':
//         'https://jp.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-%E3%82%A2%E3%83%AB%E3%83%9E-bb-%E3%83%A2%E3%83%8E%E3%82%B0%E3%83%A9%E3%83%A0-%E3%83%90%E3%83%83%E3%82%B0--M53152_PM2_Front%20view.png?wid=1080&hei=1080' //画像URL
//   },
//   {
//     'controlNumber': '12345678', //管理番号
//     'productName': '【超美品】ルイヴィトン ブラスレ・LV チェーンリンクス ブレスレット シルバー', //商品名
//     'brandName': 'LOUIS VUITTON', //ブランド名
//     'imageUrl':
//         'https://jp.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-%E3%82%A2%E3%83%AB%E3%83%9E-bb-%E3%83%A2%E3%83%8E%E3%82%B0%E3%83%A9%E3%83%A0-%E3%83%90%E3%83%83%E3%82%B0--M53152_PM2_Front%20view.png?wid=1080&hei=1080' //画像URL
//   },
//   {
//     'controlNumber': '12345678', //管理番号
//     'productName': '【超美品】ルイヴィトン ブラスレ・LV チェーンリンクス ブレスレット シルバー', //商品名
//     'brandName': 'LOUIS VUITTON', //ブランド名
//     'imageUrl':
//         'https://jp.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-%E3%82%A2%E3%83%AB%E3%83%9E-bb-%E3%83%A2%E3%83%8E%E3%82%B0%E3%83%A9%E3%83%A0-%E3%83%90%E3%83%83%E3%82%B0--M53152_PM2_Front%20view.png?wid=1080&hei=1080' //画像URL
//   },
//   {
//     'controlNumber': '12345678', //管理番号
//     'productName': '【超美品】ルイヴィトン ブラスレ・LV チェーンリンクス ブレスレット シルバー', //商品名
//     'brandName': 'LOUIS VUITTON', //ブランド名
//     'imageUrl':
//         'https://jp.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-%E3%82%A2%E3%83%AB%E3%83%9E-bb-%E3%83%A2%E3%83%8E%E3%82%B0%E3%83%A9%E3%83%A0-%E3%83%90%E3%83%83%E3%82%B0--M53152_PM2_Front%20view.png?wid=1080&hei=1080' //画像URL
//   },
//   {
//     'controlNumber': '12345678', //管理番号
//     'productName': '【超美品】ルイヴィトン ブラスレ・LV チェーンリンクス ブレスレット シルバー', //商品名
//     'brandName': 'LOUIS VUITTON', //ブランド名
//     'imageUrl':
//         'https://jp.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-%E3%82%A2%E3%83%AB%E3%83%9E-bb-%E3%83%A2%E3%83%8E%E3%82%B0%E3%83%A9%E3%83%A0-%E3%83%90%E3%83%83%E3%82%B0--M53152_PM2_Front%20view.png?wid=1080&hei=1080' //画像URL
//   },
//   {
//     'controlNumber': '12345678', //管理番号
//     'productName': '【超美品】ルイヴィトン ブラスレ・LV チェーンリンクス ブレスレット シルバー', //商品名
//     'brandName': 'LOUIS VUITTON', //ブランド名
//     'imageUrl':
//         'https://jp.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-%E3%82%A2%E3%83%AB%E3%83%9E-bb-%E3%83%A2%E3%83%8E%E3%82%B0%E3%83%A9%E3%83%A0-%E3%83%90%E3%83%83%E3%82%B0--M53152_PM2_Front%20view.png?wid=1080&hei=1080' //画像URL
//   },
//   {
//     'controlNumber': '12345678', //管理番号
//     'productName': '【超美品】ルイヴィトン ブラスレ・LV チェーンリンクス ブレスレット シルバー', //商品名
//     'brandName': 'LOUIS VUITTON', //ブランド名
//     'imageUrl':
//         'https://jp.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-%E3%82%A2%E3%83%AB%E3%83%9E-bb-%E3%83%A2%E3%83%8E%E3%82%B0%E3%83%A9%E3%83%A0-%E3%83%90%E3%83%83%E3%82%B0--M53152_PM2_Front%20view.png?wid=1080&hei=1080' //画像URL
//   },
//   {
//     'controlNumber': '12345678', //管理番号
//     'productName': '【超美品】ルイヴィトン ブラスレ・LV チェーンリンクス ブレスレット シルバー', //商品名
//     'brandName': 'LOUIS VUITTON', //ブランド名
//     'imageUrl':
//         'https://jp.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-%E3%82%A2%E3%83%AB%E3%83%9E-bb-%E3%83%A2%E3%83%8E%E3%82%B0%E3%83%A9%E3%83%A0-%E3%83%90%E3%83%83%E3%82%B0--M53152_PM2_Front%20view.png?wid=1080&hei=1080' //画像URL
//   },
//   {
//     'controlNumber': '12345678', //管理番号
//     'productName': '【超美品】ルイヴィトン ブラスレ・LV チェーンリンクス ブレスレット シルバー', //商品名
//     'brandName': 'LOUIS VUITTON', //ブランド名
//     'imageUrl':
//         'https://jp.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-%E3%82%A2%E3%83%AB%E3%83%9E-bb-%E3%83%A2%E3%83%8E%E3%82%B0%E3%83%A9%E3%83%A0-%E3%83%90%E3%83%83%E3%82%B0--M53152_PM2_Front%20view.png?wid=1080&hei=1080' //画像URL
//   },
//   {
//     'controlNumber': '12345678', //管理番号
//     'productName': '【超美品】ルイヴィトン ブラスレ・LV チェーンリンクス ブレスレット シルバー', //商品名
//     'brandName': 'LOUIS VUITTON', //ブランド名
//     'imageUrl':
//         'https://jp.louisvuitton.com/images/is/image/lv/1/PP_VP_L/louis-vuitton-%E3%82%A2%E3%83%AB%E3%83%9E-bb-%E3%83%A2%E3%83%8E%E3%82%B0%E3%83%A9%E3%83%A0-%E3%83%90%E3%83%83%E3%82%B0--M53152_PM2_Front%20view.png?wid=1080&hei=1080' //画像URL
//   },
// ];

// 在庫情報を表示するページ
// 常に在庫は入れ替わるので、StatefulWidget
class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("在庫管理アプリ"),
        backgroundColor: Color(0xFF222831),
      ),
      body: StreamBuilder<QuerySnapshot<Inventory>>(
        stream: inventoriesReference.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('エラーが発生しました');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          final docs = snapshot.data?.docs ?? [];
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (content, index) {
              final doc = docs[index].data();
              return Text(doc.name);
            },
          );
        },
      ),
      floatingActionButton: Builder(
        builder: (context) {
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
        },
      ),
    );
  }
}


// class _InventoryPageState extends State<InventoryPage> {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text("在庫管理アプリ"),
//           backgroundColor: Color(0xFF222831),
//         ),
//         body: ListView.builder(
//           itemCount: products.length,
//           itemBuilder: (context, index) {
//             return Row(
//               children: [
//                 Image.network(
//                   products[index]['imageUrl']!,
//                   height: 100.0,
//                   width: 100.0,
//                 ),
//                 Flexible(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         products[index]['controlNumber']!,
//                         style: TextStyle(
//                           color: Colors.blue[300],
//                           fontSize: 12,
//                         ),
//                       ),
//                       Text(
//                         products[index]['productName']!,
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 15,
//                         ),
//                       ),
//                       Text(
//                         products[index]['brandName']!,
//                         style: TextStyle(
//                           color: Colors.blue[300],
//                           fontSize: 12,
//                         ),
//                       ),
//                     ],
//                   ),
//                 )
//               ],
//             );
//           },
//         ),
//         floatingActionButton: Builder(builder: (context) {
//           return FloatingActionButton(
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => AddInventory(),
//                 ),
//               );
//             },
//             child: Icon(Icons.add),
//             backgroundColor: Color(0xFF222831),
//           );
//         }),
//       ),
//     );
//   }
// }

