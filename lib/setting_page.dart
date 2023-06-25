import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
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
            // onTap: () {
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(builder: (context) => BrandsSettingsPage()),
            //   );
            // },
          ),
          ListTile(
            title: Text('仕入れ先'),
            // onTap: () {
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(builder: (context) => SuppliersSettingsPage()),
            //   );
            // },
          ),
          ListTile(
            title: Text('販売先'),
            // onTap: () {
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(builder: (context) => PlatformsSettingsPage()),
            //   );
            // },
          ),
        ],
      ),
    );
  }
}
