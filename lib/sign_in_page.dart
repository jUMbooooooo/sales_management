import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'inventory_page.dart';

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
      // appBar: AppBar(
      //   title: const Text('せどりマネージャー'),
      //   backgroundColor: const Color(0xFF222831),
      // ),
      body: Center(
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(const Color(0xFF222831)),
          ),
          child: const Text('Googleアカウントでサインイン'),
          onPressed: () async {
            await logout();
            await signInWithGoogle();
            // ログインが成功すると FirebaseAuth.instance.currentUser にログイン中のユーザーの情報が入ります
            // print(FirebaseAuth.instance.currentUser?.displayName);

            if (mounted) {
              // ユーザーが正常に認証され、ユーザー情報が得られたページへ遷移
              // print('ユーザーネーム[$currentUserName]');

              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (cotext) {
                  return const InventoryPage();
                }),
                (route) => false,
              );
            }
          },
        ),
      ),
    );
  }
}
