import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

// FirebaseStorageに画像をアップロードして、ダウンロードURLを取得すること関数
Future<String> uploadImage(File imageFile) async {
  String fileName = DateTime.now().millisecondsSinceEpoch.toString();
  FirebaseStorage storage = FirebaseStorage.instance;
  Reference ref = storage.ref().child('images/$fileName');
  UploadTask uploadTask = ref.putFile(imageFile);
  await uploadTask;
  String downloadUrl = await ref.getDownloadURL();
  return downloadUrl;
}
