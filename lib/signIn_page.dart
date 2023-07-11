// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sales_management_app/user_notifier.dart';
import 'inventory_page.dart';

User? currentUser;
String? currentUserId;
String? currentUserName;

//SignInPageのクラス(設計図)
class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> {
  Future<void> signInWithGoogle(UserNotifier userNotifier) async {
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

    // // ログインが完了したらここで currentUser と currentUserId を更新します
    // currentUser = FirebaseAuth.instance.currentUser;
    // if (currentUser != null) {
    //   currentUserId = currentUser!.uid;
    //   currentUserName = currentUser!.displayName;

    // ログインが完了したらここで UserNotifier にユーザー情報をセットします
    final currentUser = FirebaseAuth.instance.currentUser;
    userNotifier.setUser(currentUser);
    // context.read(userProvider).setUser(currentUser);

    print(
        '[$currentUserId], [${currentUserName}]'); // userId と displayName を確認します
  }

  // 既存のログイン情報をクリア
  Future<void> logout(UserNotifier userNotifier) async {
    // Googleは別個でログアウトしないと次にログインするときにアカウント選択が表示されない
    final googleSignIn = GoogleSignIn();
    if (await googleSignIn.isSignedIn()) {
      await googleSignIn.signOut();
    }
    // ログアウトしたら UserNotifier のユーザー情報を null にセットします
    // context.read(userProvider).setUser(null);
    userNotifier.setUser(null);
    return FirebaseAuth.instance.signOut();
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
            // ユーザー通知者を取得します。
            // final userNotifier = context.read(userProvider);

            // print('currentUser[$currentUser]/currentUserId[$currentUserId]');
            // await logout(userNotifier); // ログアウトのメソッドにuserNotifierを渡します
            // await signInWithGoogle(
            //     userNotifier); // signInWithGoogleメソッドにuserNotifierを渡します

            if (mounted) {
              // ユーザーが正常に認証され、ユーザー情報が得られたページへ遷移
              print('[$currentUserId],[$currentUserName]');

              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) {
                  return InventoryPage();
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
