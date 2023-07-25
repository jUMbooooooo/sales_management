import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_management_app/custom_widget/drawer.dart';
import 'package:sales_management_app/inventory_class.dart';
// import 'package:sales_management_app/provider/inventory_provider.dart';
import 'add_inventory.dart';
import '../custom_widget/inventory_listview.dart';
import '../sign_in_page.dart';
import '../settings/setting_page.dart';

// 在庫情報を表示するページ
// 常に在庫は入れ替わるので、StatefulWidget

class InventoryPage extends ConsumerStatefulWidget {
  const InventoryPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _InventoryPageState();
}

class _InventoryPageState extends ConsumerState<InventoryPage> {
  // Future<void> logout(WidgetRef ref) async {
  //   await FirebaseAuth.instance.signOut(); // ログアウト
  //   await Future.delayed(const Duration(seconds: 1));
  //   ref.refresh(inventoriesProvider); // Providerのリセット
  //   print('currentUserName[$currentUserName]');
  // }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("在庫管理"),
          backgroundColor: const Color(0xFF222831),
          bottom: const TabBar(
            isScrollable: true,
            tabs: <Widget>[
              Tab(text: '出品前'),
              Tab(text: '出品中'),
              Tab(text: '発送前'),
              Tab(text: '発送済'),
              Tab(text: '取引完了'),
            ],
          ),
        ),
        drawer: const MyDrawer(),
        body: const TabBarView(
          children: <Widget>[
            InventoryList(status: InventoryStatus.notListed),
            InventoryList(status: InventoryStatus.listed),
            InventoryList(status: InventoryStatus.beforeShipping),
            InventoryList(status: InventoryStatus.shipped),
            InventoryList(status: InventoryStatus.transactionComplete),
          ],
        ),
        floatingActionButton: Builder(
          builder: (context) {
            return FloatingActionButton(
              onPressed: () {
                // print('[$currentUserId],[$currentUserName]');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddInventory(),
                  ),
                );
              },
              backgroundColor: const Color(0xFF222831),
              child: const Icon(Icons.add),
            );
          },
        ),
      ),
    );
  }
}
