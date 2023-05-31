import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'inventory_page.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  // Future<void> signInWithGoogle() async {
  //   // GoogleSignIn をして得られた情報を Firebase と関連づけることをやっています。
  //   final googleUser =
  //       await GoogleSignIn(scopes: ['profile', 'email']).signIn();

  //   final googleAuth = await googleUser?.authentication;

  //   final credential = GoogleAuthProvider.credential(
  //     accessToken: googleAuth?.accessToken,
  //     idToken: googleAuth?.idToken,
  //   );

  //   await FirebaseAuth.instance.signInWithCredential(credential);
  // }
  Future<UserCredential?> signInWithGoogle() async {
    // GoogleSignIn をして得られた情報を Firebase と関連づけることをやっています。
    final googleUser = await GoogleSignIn(scopes: ['prfile', 'email']).signIn();
    final googleAuth = await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    //ここでFirebaseの認証結果を返す
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Googleサインイン'),
        backgroundColor: Color(0xFF222831),
      ),
      body: Center(
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(Color(0xFF222831)),
          ),
          child: const Text('Googleサインイン'),
          onPressed: () async {
            final userCredential = await signInWithGoogle();
            // ログインが成功すると FirebaseAuth.instance.currentUser にログイン中のユーザーの情報が入ります
            // print(FirebaseAuth.instance.currentUser?.displayName);

            if (userCredential != null && mounted) {
              // ユーザーが正常に認証され、ユーザー情報が得られたページへ遷移
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
