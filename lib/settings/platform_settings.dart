import 'package:flutter/material.dart';

class PlatformsSettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF222831),
        title: Text('ブランド設定'),
      ),
      body: Center(
        child: Text(
          'ここにブランド設定を追加してください',
        ),
      ),
    );
  }
}
