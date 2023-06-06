//在庫の状態を管理するためのenum
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum InventoryStatus {
  notListed, // 出品前
  listed, // 出品中
  beforeShipping, // 発送前
  shipped, // 発送済
  transactionComplete, // 取引完了
}

// 在庫の状態を管理するStateNotifierクラスを作成
// StateNotifierは、Riverpodパッケージで提供されるステート管理のクラス
// 在庫の状態を更新するためのメソッドも定義
class InventoryStatusNotifier extends StateNotifier<InventoryStatus> {
  InventoryStatusNotifier() : super(InventoryStatus.notListed);

  void list() {
    state = InventoryStatus.listed;
  }

  void prepareForShipping() {
    state = InventoryStatus.beforeShipping;
  }

  void ship() {
    state = InventoryStatus.shipped;
  }

  void completeTransaction() {
    state = InventoryStatus.transactionComplete;
  }
}

// StateNotifierをProviderを使用して公開
final inventoryStatusProvider =
    StateNotifierProvider<InventoryStatusNotifier, InventoryStatus>(
  (ref) => InventoryStatusNotifier(),
);
