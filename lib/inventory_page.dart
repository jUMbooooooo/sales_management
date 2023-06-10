import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_management_app/provider/inventory_provider.dart';
import 'add_inventory.dart';

// 在庫情報を表示するページ
// 常に在庫は入れ替わるので、StatefulWidget

class InventoryPage extends ConsumerStatefulWidget {
  const InventoryPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _InventoryPageState();
}

class _InventoryPageState extends ConsumerState<InventoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("在庫管理アプリ"),
        backgroundColor: Color(0xFF222831),
      ),
      body: ref.watch(inventoriesProvider).when(data: (data) {
        return ListView.builder(
          itemCount: data.docs.length,
          itemBuilder: (context, index) {
            final doc = data.docs[index].data();
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 70,
                      width: 70,
                      child: Image.network(doc.imageUrl),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              doc.id,
                              style: const TextStyle(fontSize: 13.0),
                            ),
                            const Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: 15.0)),
                            Text(
                              doc.brand,
                              style: const TextStyle(fontSize: 13.0),
                            ),
                          ],
                        ),
                        const Padding(
                            padding: EdgeInsets.symmetric(vertical: 4.0)),
                        Text(
                          doc.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 17.0,
                          ),
                        ),
                        const Padding(
                            padding: EdgeInsets.symmetric(vertical: 3.0)),
                        Row(
                          children: [
                            Column(
                              children: [
                                Text(
                                  '仕入れ価格',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 11.0,
                                  ),
                                ),
                                Text(
                                  '${doc.buyingPrice.toInt()} 円',
                                  style: const TextStyle(fontSize: 12.0),
                                ),
                              ],
                            ),
                            // Padding(padding: EdgeInsets.all(8.0)),
                            // Column(
                            //   children: [
                            //     Text(
                            //       '販売価格',
                            //       style: const TextStyle(
                            //         fontWeight: FontWeight.w500,
                            //         fontSize: 11.0,
                            //       ),
                            //     ),
                            //     Text(
                            //       '${doc.buyingPrice.toInt()} 円',
                            //       style: const TextStyle(fontSize: 12.0),
                            //     ),
                            //   ],
                            // ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
            // return ListTile(
            //   // leading: ,
            //   title: Text(doc.name),
            //   subtitle: Text(doc.id),
            //   // trailing: ,
            // );
          },
        );
      }, error: (_, __) {
        return const Center(
          child: Text('エラーが出ました。'),
        );
      }, loading: () {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }),
      // StreamBuilder<QuerySnapshot<Inventory>>(
      //   stream: inventoriesReference.snapshots(),
      //   builder: (context, snapshot) {
      //     if (snapshot.hasError) {
      //       return Text('エラーが発生しました');
      //     }

      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return CircularProgressIndicator();
      //     }

      //     final docs = snapshot.data?.docs ?? [];
      //     return ListView.builder(
      //       itemCount: docs.length,
      //       itemBuilder: (content, index) {
      //         final doc = docs[index].data();
      //         return Text(doc.name);
      //       },
      //     );
      //   },
      // ),
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

