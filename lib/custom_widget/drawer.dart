import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_management_app/settings/setting_page.dart';
import 'package:sales_management_app/sign_in_page.dart';

class MyDrawer extends ConsumerWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
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
                MaterialPageRoute(builder: (context) => const SettingsPage()),
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
            onTap: () async {
              // await logout(ref); // ログアウト処理
              // ログアウト処理
              FirebaseAuth.instance.signOut();
              // // User? currentUser = null;
              // // var currentUserId = '';
              // // var currentUserName = '';
              // context.refresh(inventoriesProvider); // Providerのリセット
              // print('currentUserName[$currentUserName]');

              // ログイン画面に遷移
              // await Future.delayed(const Duration(seconds: 1));
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const SignInPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
