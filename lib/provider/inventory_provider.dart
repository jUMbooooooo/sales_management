import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_management_app/main.dart';

/// 全投稿データをstreamで提供するProvider
final inventoriesProvider = StreamProvider((ref) {
  return inventoriesReference.snapshots();
});
