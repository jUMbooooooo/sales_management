import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_management_app/provider/inventory_provider.dart';
import 'brands_settings.dart';
import 'supplier_settings.dart';
import 'platform_settings.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              final userId = ref.watch(userIdProvider);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BrandsSettingsPage(userId!)),
              );
            },
          ),
          ListTile(
            title: const Text('仕入れ先'),
            onTap: () {
              final userId = ref.watch(userIdProvider);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SupplierSettingsPage(userId!)),
              );
            },
          ),
          ListTile(
            title: const Text('販売先'),
            onTap: () {
              final userId = ref.watch(userIdProvider);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PlatformSettingsPage(userId!)),
              );
            },
          ),
        ],
      ),
    );
  }
}
