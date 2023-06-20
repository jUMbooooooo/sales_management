import 'package:flutter/material.dart';
import 'package:sales_management_app/inventory_class.dart';
import 'package:sales_management_app/provider/inventory_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../edit_inventory.dart';

class InventoryList extends ConsumerWidget {
  final InventoryStatus status;

  const InventoryList({
    Key? key,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(inventoriesProvider).when(
      data: (List<Inventory> inventories) {
        var filteredDocs = inventories
            .where((inventory) => inventory.status == status)
            .toList();
        // ref.watch(inventoriesProvider).when(
        //   data: (data) {
        //     var filteredDocs =
        //         data.docs.where((doc) => doc.data().status == status).toList();

        print(filteredDocs);

        if (filteredDocs.isEmpty) {
          return const SizedBox.shrink();
        }

        return ListView.builder(
          itemCount: filteredDocs.length,
          itemBuilder: (context, index) {
            final doc = filteredDocs[index];
            String inventoryId;
            return Material(
              // InkWell requires a Material widget
              child: InkWell(
                // <--- Wrap each item with InkWell
                onLongPress: () {
                  showMenu(
                    context: context,
                    position:
                        const RelativeRect.fromLTRB(50.0, 50.0, 50.0, 50.0),
                    items: <PopupMenuEntry>[
                      const PopupMenuItem(
                        child: Text("編集"),
                        value: 'edit',
                      ),
                      // PopupMenuItem(
                      //   child: Text("削除"),
                      //   value: "Option 2",
                      // ),
                      //... Add more options as you need
                    ],
                    elevation: 8.0,
                  ).then(
                    (value) {
                      if (value != null) {
                        print('You selected: $value');
                        // Here you can handle the selected option
                        // For example, navigate to a different screen or modify the item
                        if (value == "edit") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditInventory()),
                          );
                        }
                      }
                    },
                  );
                },

                child: Padding(
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
                ),
              ),
            );
          },
        );
      },
      error: (_, __) {
        return const Center(
          child: Text('エラーが出ました。'),
        );
      },
      loading: () {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
