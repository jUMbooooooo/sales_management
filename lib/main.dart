import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:googleapis/firebaseremoteconfig/v1.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:sales_management_app/firebase_options.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

import 'sign_in_page.dart';
import 'dart:io';

// Firebaseの初期化
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final remoteConfig = FirebaseRemoteConfig.instance;

  remoteConfig.setDefaults({
    'force_update_required': false,
    'minimum_app_version': '1.0.0',
  });
  await remoteConfig.fetchAndActivate();

  final packageInfo = await PackageInfo.fromPlatform();
  String currentAppVersion = packageInfo.version;

  // Platform specific initialization
  if (Platform.isAndroid) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.android,
    );
  } else if (Platform.isIOS) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.ios,
    );
  }

  runApp(ProviderScope(
      child: MyApp(
    currentAppVersion: currentAppVersion,
    remoteConfig: remoteConfig,
  )));
}

// MyAppをビルド
// SignInPageを表示させている
class MyApp extends StatelessWidget {
  final String currentAppVersion;
  final FirebaseRemoteConfig remoteConfig;

  const MyApp(
      {Key? key, required this.currentAppVersion, required this.remoteConfig})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String minimumAppVersion = remoteConfig.getString('minimum_app_version');
    if (currentAppVersion != minimumAppVersion) {
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('新しいバージョンが利用可能です'),
                ElevatedButton(
                  child: Text('アップデート'),
                  onPressed: () {
                    // ここにアップデートを促すコードを追加
                  },
                ),
              ],
            ),
          ),
        ),
      );
    }

    return MaterialApp(
      theme: ThemeData(),
      home: const SignInPage(),
    );
  }
}
