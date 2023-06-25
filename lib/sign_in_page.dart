import 'package:cloud_firestore/cloud_firestore.dart';
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

    final userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    // 登録ユーザーまたはサインインユーザーのFirestoreへの保存
    final user = userCredential.user;
    final userReference =
        FirebaseFirestore.instance.collection('users').doc(user?.uid);

    // 初めてのログインなら、ブランドコレクションを作成します
    final brands = await userReference.collection('brands').get();
    if (brands.docs.isEmpty) {
      userReference.collection('brands').add({});
    }
  }

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


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         // decoration: BoxDecoration(
//         //   image: DecorationImage(
//         //     image: AssetImage("assets/background_image.jpg"), //背景画像を設定
//         //     fit: BoxFit.cover,
//         //   ),
//         // ),
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Text(
//                 "ようこそ",
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 40.0,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               SizedBox(height: 30.0),
//               Text(
//                 "Sign in to continue",
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 18.0,
//                 ),
//               ),
//               SizedBox(height: 50.0),
//               ElevatedButton(
//                 style: ButtonStyle(
//                   backgroundColor: MaterialStateProperty.all<Color>(
//                       Colors.white), //ボタンの色を白に設定
//                   padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
//                     EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
//                   ),
//                   shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                     RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(30.0),
//                     ),
//                   ),
//                 ),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: <Widget>[
//                     // Image(
//                     //   image:
//                     //       AssetImage("assets/google_icon.png"), //Googleのアイコンを設定
//                     //   height: 30.0,
//                     // ),
//                     SizedBox(width: 10.0),
//                     Text(
//                       'Googleアカウントでサインイン',
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontSize: 20.0,
//                       ),
//                     ),
//                   ],
//                 ),
//                 onPressed: () async {
//                   await logout();
//                   await signInWithGoogle();

//                   if (mounted) {
//                     // ユーザーが正常に認証され、ユーザー情報が得られたページへ遷移
//                     print('[$currentUserId],[$currentUserName]');

//                     Navigator.of(context).pushAndRemoveUntil(
//                       MaterialPageRoute(builder: (cotext) {
//                         return const InventoryPage();
//                       }),
//                       (route) => false,
//                     );
//                   }
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
