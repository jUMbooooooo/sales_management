import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'inventory_page.dart';

final currentUser = FirebaseAuth.instance.currentUser!;

final currentUserId = currentUser.uid;
final currentUserName = currentUser.displayName!;

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
    final googleUser =
        await GoogleSignIn(scopes: ['profile', 'email']).signIn();

    final googleAuth = await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(credential);
  }

  // // Firebaseの認証(非同期処理)
  // Future<UserCredential?> signInWithGoogle() async {
  //   // GoogleSignIn をして得られた情報を Firebase と関連づけることをやっています。
  //   final googleUser =
  //       await GoogleSignIn(scopes: ['profile', 'email']).signIn();
  //   final googleAuth = await googleUser?.authentication;

  //   final credential = GoogleAuthProvider.credential(
  //     accessToken: googleAuth?.accessToken,
  //     idToken: googleAuth?.idToken,
  //   );

  //   //ここでFirebaseの認証結果を返す
  //   return await FirebaseAuth.instance.signInWithCredential(credential);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Googleサインイン'),
        backgroundColor: const Color(0xFF222831),
      ),
      body: Center(
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(const Color(0xFF222831)),
          ),
          child: const Text('Googleサインイン'),
          onPressed: () async {
            await logout();
            await signInWithGoogle();
            // ログインが成功すると FirebaseAuth.instance.currentUser にログイン中のユーザーの情報が入ります
            // print(FirebaseAuth.instance.currentUser?.displayName);

            if (mounted) {
              // ユーザーが正常に認証され、ユーザー情報が得られたページへ遷移
              print('[$currentUserId],[$currentUserName]');

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
