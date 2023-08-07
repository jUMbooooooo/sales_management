import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:version/version.dart';

import 'package:sales_management_app/firebase_options.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:url_launcher/url_launcher.dart';

import 'sign_in_page.dart';
import 'dart:io';

// Firebaseの初期化
// Firebaseの初期化
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

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

  final remoteConfig = FirebaseRemoteConfig.instance;

  remoteConfig.setDefaults({
    'force_update_required': false,
    'minimum_app_version': '1.0.0',
  });

  try {
    await remoteConfig.fetchAndActivate();
  } catch (e) {
    print('Remote Config fetch error: $e');
  }

  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  String currentAppVersion = packageInfo.version;
  print('currentAppVersion{$currentAppVersion}');

  runApp(ProviderScope(
      child: MyApp(
    currentAppVersion: currentAppVersion,
    remoteConfig: remoteConfig,
  )));
}

class MyApp extends StatefulWidget {
  final String currentAppVersion;
  final FirebaseRemoteConfig remoteConfig;

  const MyApp(
      {Key? key, required this.currentAppVersion, required this.remoteConfig})
      : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<void> _launchURL(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    String minimumAppVersion =
        widget.remoteConfig.getString('minimum_app_version');
    Version currentVersion = Version.parse(widget.currentAppVersion);
    Version minimumVersion = Version.parse(minimumAppVersion);
    bool forceUpdateRequired =
        widget.remoteConfig.getBool('force_update_required');
    String updateUrl;
    print('currentVersion{$currentVersion}');
    if (Platform.isAndroid) {
      updateUrl =
          'https://play.google.com/store/apps/details?id=YOUR_PACKAGE_NAME';
    } else if (Platform.isIOS) {
      updateUrl = 'https://apps.apple.com/app/idYOUR_APP_ID';
    } else {
      updateUrl = '';
    }

    if (currentVersion < minimumVersion) {
      return MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Text('新しいバージョンが利用可能です'),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color(0xFF222831)),
                    ),
                    child: const Text('アップデート'),
                    onPressed: () {
                      _launchURL(Uri.parse(updateUrl));
                    },
                  ),
                  if (!forceUpdateRequired)
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color(0xFF222831)),
                      ),
                      child: const Text('キャンセル'),
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignInPage()));
                      },
                    ),
                ],
              ),
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
