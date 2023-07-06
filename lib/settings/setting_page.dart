import 'package:flutter/material.dart';
import 'package:sales_management_app/main.dart';
import 'brands_settings.dart';
import 'supplier_settings.dart';
import 'platform_settings.dart';

class SettingsPage extends StatelessWidget {
  final String userId = currentUserId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF222831),
        title: Text('設定'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('ブランド名'),
            onTap: () {
              final String userId = currentUserId;
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BrandsSettingsPage(userId)),
              );
            },
          ),
          ListTile(
            title: Text('仕入れ先'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SupplierSettingsPage(userId)),
              );
            },
          ),
          ListTile(
            title: Text('販売先'),
            onTap: () {
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
