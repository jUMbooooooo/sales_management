import 'package:sales_management_app/inventory_class.dart';

class SalesAnalytics {
  Map<String, double> calculateMonthlyData(
      List<Inventory> inventories, int month, int year) {
    double totalSales = 0; //売上
    double totalCosts = 0; //売上原価
    // 新しく追加される計算部分
    int salesCount = inventories
        .where((inv) => inv.status == InventoryStatus.transactionComplete)
        .length;
    double avgSalesPrice = totalSales / salesCount;

    // 入金額などの情報はInventoryクラスには存在しないので、ここでは一時的に0とします
    double depositAmount = 0;

    double totalShippingCosts =
        inventories.fold(0, (prev, inv) => prev + (inv.shippingCost ?? 0));
    double avgShippingCost = totalShippingCosts / salesCount;

    int buyingCount = inventories.length;
    double totalBuyingPrice =
        inventories.fold(0, (prev, inv) => prev + inv.buyingPrice);
    double avgBuyingPrice = totalBuyingPrice / buyingCount;

    // Selling fee and other necessary fees
    double sellingFees =
        0; // Need to be calculated based on your business logic
    double avgSellingFee = sellingFees / salesCount;

    double profit = totalSales - totalCosts - sellingFees;
    double profitRatio = profit / totalSales * 100;

    // Balance and balance rate
    double balance = totalSales - totalCosts - sellingFees - depositAmount;
    double balanceRate = balance / totalSales * 100;

    final start = DateTime(year, month);
    final end = DateTime(year, month + 1);

    for (final inventory in inventories) {
      if (inventory.date.toDate().isAfter(start) &&
          inventory.date.toDate().isBefore(end)) {
        if (inventory.sellingPrice != null) {
          totalSales += inventory.sellingPrice!;
        }
        totalCosts += inventory.buyingPrice + inventory.otherCosts;
      }
    }
    return {
      'sales': totalSales,
      'costs': totalCosts,
      'salesCount': salesCount as double,
      'avgSalesPrice': avgSalesPrice,
      'depositAmount': depositAmount,
      'totalShippingCosts': totalShippingCosts,
      'avgShippingCost': avgShippingCost,
      'buyingCount': buyingCount as double,
      'totalBuyingPrice': totalBuyingPrice,
      'avgBuyingPrice': avgBuyingPrice,
      'sellingFees': sellingFees,
      'avgSellingFee': avgSellingFee,
      'profit': profit,
      'profitRatio': profitRatio,
      'balance': balance,
      'balanceRate': balanceRate,
    };
  }
}
