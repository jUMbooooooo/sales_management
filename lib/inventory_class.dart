import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// 在庫の状態を管理するenum関数
enum InventoryStatus {
  notListed, // 出品前
  listed, // 出品中
  beforeShipping, // 発送前
  shipped, // 発送済
  transactionComplete, // 取引完了
}

// 在庫の状態を日本語で表示するためのヘルパー関数
String inventoryStatusToJapanese(InventoryStatus status) {
  switch (status) {
    case InventoryStatus.notListed:
      return '出品前';
    case InventoryStatus.listed:
      return '出品中';
    case InventoryStatus.beforeShipping:
      return '発送前';
    case InventoryStatus.shipped:
      return '発送済';
    case InventoryStatus.transactionComplete:
      return '取引完了';
  }
}

class Inventory {
  Inventory({
    required this.imageUrl,
    required this.date,
    required this.id,
    required this.brand,
    required this.name,
    required this.buyingPrice,
    required this.otherCosts,
    required this.supplier,
    required this.status,
    this.purchasedDate,
    this.sellingPrice,
    this.sellLocation,
    this.shippingCost,
    this.salesDate,
    this.salesFee, //販売手数料
    this.depositAmount, //入金額
    this.profit, //粗利
    this.profitRatio, //粗利益率
    this.salesPeriod, //販売期間
    this.feeRate, //手数料率
    required this.reference,
  });

  InventoryStatus status;

  factory Inventory.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final map = snapshot.data()!;

    // feeRateをFirestoreから取得します
    double? feeRate = map['feeRate'] ?? 0.0;

    return Inventory(
      date: map['date'],
      id: map['id'],
      imageUrl: map['imageUrl'],
      brand: map['brand'],
      name: map['name'],
      buyingPrice: map['buyingPrice'],
      otherCosts: map['otherCosts'],
      supplier: map['supplier'],
      purchasedDate: map['purchasedDate'],
      sellingPrice: map['sellingPrice'],
      sellLocation: map['sellLocation'],
      shippingCost: map['shippingCost'],
      salesDate: map['salesDate'],
      salesPeriod: map['salesPeriod'], //販売期間
      depositAmount: map['depositAmount'], //入金額
      salesFee: map['salesFee'], //販売手数料
      profit: map['profit'], //粗利
      profitRatio: map['profitRatio'], //粗利益率
      feeRate: feeRate,
      status: InventoryStatus.values.firstWhere(
          (e) => e.toString() == 'InventoryStatus.${map['status']}'),
      // リファレンスは、コレクションとドキュメントIDの組み合わせをパスコードで示したもの
      // uers/userId/ reference.id
      reference: snapshot.reference,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'imageUrl': imageUrl,
      'date': date,
      'id': id,
      'brand': brand,
      'name': name,
      'buyingPrice': buyingPrice,
      'otherCosts': otherCosts,
      'supplier': supplier,
      'purchasedDate': purchasedDate,
      'sellingPrice': sellingPrice,
      'sellLocation': sellLocation,
      'shippingCost': shippingCost,
      'salesDate': salesDate,
      'salesPeriod': salesPeriod,
      'depositAmount': depositAmount,
      'salesFee': salesFee,
      'profit': profit,
      'profitRatio': profitRatio,
      'status': status.toString().split('.').last,
      'feeRate': feeRate,
    };
  }

  late String imageUrl; //商品画像(ファイルのパスを指定してpick)
  late Timestamp date; //仕入れ日
  late String id; //管理番号
  late String brand; //ブランド名
  late String name; //商品名
  late double buyingPrice; //仕入れ価格
  late double otherCosts; //仕入れ送料+その他コスト
  late String supplier; //仕入れ先
  late Timestamp? purchasedDate; //購入日時
  late double? sellingPrice; //販売価格
  late String? sellLocation; //販売先
  late double? feeRate;
  late double? shippingCost; //販売時送料
  late Timestamp? salesDate; //売上日時
  late int? salesPeriod; //販売期間
  late double? depositAmount; //入金額
  late double? salesFee;
  late double? profit;
  late double? profitRatio;
  final DocumentReference reference; //リファレンス

  void setSellLocation(String locationName) async {
    // Set the sell location
    sellLocation = locationName;

    // Fetch the corresponding fee rate from Firestore
    final currentUser = FirebaseAuth.instance.currentUser!;
    final currentUserId = currentUser.uid;
    final userReference =
        FirebaseFirestore.instance.collection('users').doc(currentUserId);

    final querySnapshot = await userReference
        .collection('sellLocation')
        .where('locationName', isEqualTo: locationName)
        .get();

    final documents = querySnapshot.docs;

    if (documents.isNotEmpty) {
      final document = documents[0];
      feeRate = document.data()['feeRate'] ?? 0.0;
    }
  }

  void calculateValues() {
    // 販売手数料の計算
    salesFee = sellingPrice! * feeRate!;

    // 入金額の計算
    depositAmount = sellingPrice! - salesFee!;

    // 粗利の計算
    profit =
        depositAmount! - (buyingPrice + otherCosts + (shippingCost ?? 0.0));

    // 粗利益率の計算
    profitRatio = (profit! / depositAmount!) * 100;

    // 販売期間の計算 (Duration オブジェクトを使用)
    if (salesDate != null && purchasedDate != null) {
      salesPeriod =
          salesDate!.toDate().difference(purchasedDate!.toDate()) as int?;
    }
  }
}
