import 'package:cloud_firestore/cloud_firestore.dart';

enum InventoryStatus {
  notListed, // 出品前
  listed, // 出品中
  beforeShipping, // 発送前
  shipped, // 発送済
  transactionComplete, // 取引完了
}

class Inventory {
  Inventory({
    // required this.image,
    required this.date,
    required this.id,
    required this.brand,
    required this.name,
    required this.buyingPrice,
    required this.otherCosts,
    required this.supplier,
    required this.status,
    // required this.inspection,
    // required this.purchased,
    // required this.purchasedDate,
    // required this.sellgPrice,
    // required this.sellLocation,
    // required this.shippingCost,
    // required this.salesDate,
    // required this.revenue,
    required this.reference,
  });

  InventoryStatus status;

  factory Inventory.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final map = snapshot.data()!;

    return Inventory(
      // image: map['image'],
      date: map['date'],
      id: map['id'],
      brand: map['brand'],
      name: map['name'],
      buyingPrice: map['buyingPrice'],
      otherCosts: map['otherCosts'],
      supplier: map['supplier'],
      // inspection: map['inspection'],
      // purchased: map['purchased'],
      // purchasedDate: map['purchasedDate'],
      // sellgPrice: map['sellgPrice'],
      // sellLocation: map['sellLocation'],
      // shippingCost: map['shippingCost'],
      // salesDate: map['salesDate'],
      // revenue: map['revenue'],
      status: InventoryStatus.values.firstWhere(
          (e) => e.toString() == 'InventoryStatus.${map['status']}'),
      reference: snapshot.reference,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      // 'image': image,
      'date': date,
      'id': id,
      'brand': brand,
      'name': name,
      'buyingPrice': buyingPrice,
      'otherCosts': otherCosts,
      'supplier': supplier,
      // 'inspection': inspection,
      // 'purchased': purchased,
      // 'purchasedDate': purchasedDate,
      // 'sellgPrice': sellgPrice,
      // 'sellLocation': sellLocation,
      // 'shippingCost': shippingCost,
      // 'salesDate': salesDate,
      // 'revenue': revenue,
      'status': status.toString().split('.').last,
    };
  }

  // late String image; //商品画像(ファイルのパスを指定してpick)
  late Timestamp date; //仕入れ日
  late String id; //管理番号
  late String brand; //ブランド名
  late String name; //商品名
  late double buyingPrice; //仕入れ価格
  late double otherCosts; //仕入れ送料+その他コスト
  late String supplier; //仕入れ先
  // late bool inspection; //検品チェック(状態として)
  // late bool purchased; //購入チェック(状態として)
  // late Timestamp purchasedDate; //購入日時
  // late double sellgPrice; //販売価格
  // late String sellLocation; //販売先
  // late double shippingCost; //販売時送料
  // late Timestamp salesDate; //売上日時
  // late bool revenue; //売上
  final DocumentReference reference;
}
