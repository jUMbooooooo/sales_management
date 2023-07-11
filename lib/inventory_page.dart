import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_management_app/inventory_class.dart';
// import 'package:sales_management_app/provider/inventory_provider.dart';
import 'add_inventory.dart';
import 'custom_widget/inventory_listview.dart';
import 'sign_in_page.dart';
import 'settings/setting_page.dart';

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
    return DefaultTabController(
      initialIndex: 0,
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("在庫管理"),
          backgroundColor: const Color(0xFF222831),
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(text: '出品前'),
              Tab(text: '出品中'),
              Tab(text: '発送前'),
              Tab(text: '発送済'),
              Tab(text: '取引完了'),
            ],
          ),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: Color(0xFF222831),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment:
                      MainAxisAlignment.spaceEvenly, // 子ウィジェット間のスペースを均等に分配
                  children: [
                    Image.asset(
                      'assets/images/SedoriManager_Appicons_2_white.png',
                      width: 140,
                      height: 50, // 画像の高さを制限します。この値は適宜調整してください
                      fit: BoxFit.cover, // 画像のアスペクト比を維持しながら、指定した空間にフィットさせます
                    ),
                    const Text(
                      'アカウント',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      FirebaseAuth.instance.currentUser?.email ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                title: const Text(
                  '設定',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsPage()),
                  );
                },
              ),
              ListTile(
                title: const Text(
                  'ログアウト',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                onTap: () {
                  // ログアウト処理
                  FirebaseAuth.instance.signOut();
                  User? currentUser = null;
                  var currentUserId = '';
                  var currentUserName = '';

                  print('currentUserName[$currentUserName]');

                  // ログイン画面に遷移
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const SignInPage()),
                  );
                },
              ),
            ],
          ),
        ),
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
                print('[$currentUserId],[$currentUserName]');
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
