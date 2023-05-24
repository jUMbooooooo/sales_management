import 'package:flutter/material.dart';
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
    required this.supplier,
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

  factory InventoryItem.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final map = snapshot.data()!;

    return InventoryItem(
      image: map['image'],
      date: map['date'],
      id: map['id'],
      brand: map['brand'],
      name: map['name'],
      buyingPrice: map['buyingPrice'],
      otherCosts: map['otherCosts'],
      supplier: map['supplier'],
      inspection: map['inspection'],
      purchased: map['purchased'],
      purchasedDate: map['purchasedDate'],
      sellgPrice: map['sellgPrice'],
      sellLocation: map['sellLocation'],
      shippingCost: map['shippingCost'],
      salesDate: map['salesDate'],
      revenue: map['revenue'],
      reference: snapshot.reference,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'image': image,
      'date': date,
      'id': id,
      'brand': brand,
      'name': name,
      'buyingPrice': buyingPrice,
      'otherCosts': otherCosts,
      'supplier': supplier,
      'inspection': inspection,
      'purchased': purchased,
      'purchasedDate': purchasedDate,
      'sellgPrice': sellgPrice,
      'sellLocation': sellLocation,
      'shippingCost': shippingCost,
      'salesDate': salesDate,
      'revenue': revenue,
    };
  }

  late String image; //商品画像(ファイルのパスを指定してpick)
  late Timestamp date; //仕入れ日
  late String id; //管理番号
  late List<DropdownMenuItem<String>> brand; //ブランド名
  late List<DropdownMenuItem<String>> name; //商品名
  late double buyingPrice; //仕入れ価格
  late double otherCosts; //仕入れ送料+その他コスト
  late List<DropdownMenuItem<String>> supplier; //仕入れ先
  late bool inspection; //検品チェック(状態として)
  late bool purchased; //購入チェック(状態として)
  late Timestamp purchasedDate; //購入日時
  late double sellgPrice; //販売価格
  late List<DropdownMenuItem<String>> sellLocation; //販売先
  late double shippingCost; //販売時送料
  late Timestamp salesDate; //売上日時
  late bool revenue; //売上
  final DocumentReference reference;
}
