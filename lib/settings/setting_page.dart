import 'package:flutter/material.dart';
import 'package:sales_management_app/provider/inventory_provider.dart';
import 'brands_settings.dart';
import 'supplier_settings.dart';
import 'platform_settings.dart';

// ignore: use_key_in_widget_constructors
class SettingsPage extends StatelessWidget {
  // final String userId = currentUserId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF222831),
        title: const Text('設定'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: const Text('ブランド名'),
            onTap: () {
              String userId = ref.watch(userIdProvider);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BrandsSettingsPage(userId)),
              );
            },
          ),
          ListTile(
            title: const Text('仕入れ先'),
            onTap: () {
              String userId = currentUserId;
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SupplierSettingsPage(userId)),
              );
            },
          ),
          ListTile(
            title: const Text('販売先'),
            onTap: () {
              String userId = currentUserId;
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PlatformSettingsPage(userId)),
              );
            },
          ),
        ],
      ),
    );
  }
}
