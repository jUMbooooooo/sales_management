import 'package:flutter/material.dart';
import 'package:sales_management_app/inventory_class.dart';
import 'package:sales_management_app/provider/inventory_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../inventories_page/edit_inventory.dart';

class InventoryList extends ConsumerWidget {
  final InventoryStatus status;

  const InventoryList({
    Key? key,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(inventoriesProvider).when(
      data: (List<Inventory> inventories) //ここでinventory一覧を取得済み
          {
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
            // docはInventory一つ一つ
            final doc = filteredDocs[index];
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
                        child: Text("編集"), //名前付き引数の簡単な例
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
                              builder: (context) => EditInventory(
                                inventoryId: doc.reference.id,
                              ),
                            ),
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
                        padding: const EdgeInsets.all(8.0),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Text(
                                      '仕入れ価格',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 11.0,
                                      ),
                                    ),
                                    Text(
                                      '${doc.buyingPrice.toInt() + doc.otherCosts.toInt()} 円',
                                      style: const TextStyle(fontSize: 12.0),
                                    ),
                                  ],
                                ),
                                Padding(padding: EdgeInsets.all(8.0)),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      doc.sellingPrice == null
                                          ? 'メルカリ損益分岐価格'
                                          : '販売価格',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 11.0,
                                      ),
                                    ),
                                    Text(
                                      doc.sellingPrice == null
                                          ? '${((doc.buyingPrice + 520) / 0.9).toInt()} 円'
                                          : '${doc.sellingPrice?.toInt()} 円',
                                      style: const TextStyle(fontSize: 12.0),
                                    ),
                                  ],
                                ),
                                Padding(padding: EdgeInsets.all(8.0)),
                                if (doc.sellingPrice != null)
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        '粗利益',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 11.0,
                                        ),
                                      ),
                                      Text(
                                        '${doc.profit != null ? doc.profit!.round() : 'N/A'}円',
                                        style: const TextStyle(fontSize: 12.0),
                                      ),
                                    ],
                                  ),
                                Padding(padding: EdgeInsets.all(8.0)),
                                if (doc.sellingPrice != null)
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        '利益率',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 11.0,
                                        ),
                                      ),
                                      Padding(padding: EdgeInsets.all(1.5)),
                                      Text(
                                        '${doc.profitRatio! * 100} %',
                                        style: const TextStyle(fontSize: 12.0),
                                      ),
                                    ],
                                  ),
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
      error: (_, error) {
        print('${error.toString()}');
        return Center(
          child: Text('エラーが出ました。:${error.toString()}'),
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
