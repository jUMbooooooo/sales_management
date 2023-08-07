import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'base_page.dart';

// User currentUser = FirebaseAuth.instance.currentUser!;

// var currentUserId = currentUser.uid;
// var currentUserName = currentUser.displayName!;

//SignInPageのクラス(設計図)
class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  String appVersion = "";

  @override
  void initState() {
    super.initState();
    // アプリのバージョンを取得
    getAppVersion();
  }

  void getAppVersion() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      appVersion = packageInfo.version;
    });
  }

  // 既存のログイン情報をクリア
  Future<void> logout() async {
    // Googleは別個でログアウトしないと次にログインするときにアカウント選択が表示されない
    final googleSignIn = GoogleSignIn();
    if (await googleSignIn.isSignedIn()) {
      await googleSignIn.signOut();
    }

    return FirebaseAuth.instance.signOut();
  }

  Future<void> signInWithGoogle() async {
// 既存のログイン情報をクリア

    // GoogleSignIn をして得られた情報を Firebase と関連づけることをやっています。
    var googleUser = await GoogleSignIn(scopes: ['profile', 'email']).signIn();
    var googleAuth = await googleUser?.authentication;
    var credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(credential);

    // ログインが完了したらここで currentUser と currentUserId を取得します
    // var currentUser = FirebaseAuth.instance.currentUser!;
    // var currentUserId = currentUser.uid;

    // print('ユーザーネーム[$currentUserName]'); // userId と displayName を確認します
    print('appVersion[$appVersion]');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/images/SedoriManager_Appicons_2_white.png',
          height: 140,
        ),
        backgroundColor: const Color(0xFF222831),
      ),
      body: Stack(
        children: [
          Center(
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(const Color(0xFF222831)),
              ),
              child: const Text('Googleアカウントでサインイン'),
              onPressed: () async {
                await logout();
                await signInWithGoogle();

                if (mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (cotext) {
                      return const BasePage(
                        title: '',
                      );
                    }),
                    (route) => false,
                  );
                }
              },
            ),
          ),
          Positioned(
            right: 10,
            bottom: 10,
            child: Text(
              'version: $appVersion',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
