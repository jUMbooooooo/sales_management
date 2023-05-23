import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:googleapis/storage/v1.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InventoryItem {
  InventoryItem({
    required this.image,
    required this.date,
    required this.id,
    required this.brand,
    required this.name,
    required this.buyingPrice,
    required this.otherCosts,
    required this.spplier,
    required this.inspection,
    required this.purchased,
    required this.purchasedDate,
    required this.sellgPrice,
    required this.sellLocation,
    required this.shippingCost,
    required this.salesDate,
    required this.revenue,
    required this.reference,
  });

  late String image; //商品画像(ファイルのパスを指定してpick)
  late DateTime date; //仕入れ日
  late String id; //管理番号
  late List<DropdownMenuItem<String>> brand; //ブランド名
  late List<DropdownMenuItem<String>> name; //商品名
  late double buyingPrice; //仕入れ価格
  late double otherCosts; //仕入れ送料+その他コスト
  late List<DropdownMenuItem<String>> spplier; //仕入れ先
  late bool inspection; //検品チェック(状態として)
  late bool purchased; //購入チェック(状態として)
  late DateTime purchasedDate; //購入日時
  late double sellgPrice; //販売価格
  late List<DropdownMenuItem<String>> sellLocation; //販売先
  late double shippingCost; //販売時送料
  late DateTime salesDate; //売上日時
  late bool revenue; //売上
  final DocumentReference reference;
}
