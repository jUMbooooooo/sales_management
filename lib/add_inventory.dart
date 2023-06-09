import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sales_management_app/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import 'upload_image_to_storage.dart';
import 'inventory_class.dart';

// フォームの状態を管理するためのキー
final _formKey = GlobalKey<FormState>();

// ブランド名のプルダウンリストの中身
List<String> brands = ['LOUIS VUITTON', 'CHANEL', 'GUCCI', 'PRADA', 'HERMES'];
final _selectedBrand = ValueNotifier<String?>(null);
final _imageController = ValueNotifier<String?>(null);
// TextFormFieldに入力されるテキストを操作するためのWidget
// for getting the corrent text, updating the text, listening for change
TextEditingController _datecontroller = TextEditingController();
TextEditingController _idController = TextEditingController();
TextEditingController _nameController = TextEditingController();
TextEditingController _buyingPriceController = TextEditingController();
TextEditingController _otherCostsController = TextEditingController();
TextEditingController _supplierController = TextEditingController();
final _statusController = ValueNotifier<InventoryStatus?>(null);

// 在庫追加のためのクラス(設計図)の作成
// なぜStatefulWidgetがいいのかわかっていない(未解決)
class AddInventory extends ConsumerStatefulWidget {
  const AddInventory({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddInventoryState();
}

<<<<<<< HEAD
// 在庫追加クラス
class _AddInventoryState extends State<AddInventory> {
  // 入力された画像やテキストをデータとして持つ

=======
class _AddInventoryState extends ConsumerState<AddInventory> {
>>>>>>> origin/main
  @override
  Widget build(BuildContext context) {
    // return MaterialApp
    // 新しい画面を作成するたびに改めて新しいMaterialAppを作成するのは適切ではない
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text("在庫追加"),
        backgroundColor: Color(0xFF222831),
      ),
      //TextFormFieldにキーボードが重なった場合のエラーを防ぐ(スクロール可能にする)
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  readOnly: true,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: Colors.black,
                        width: 2.0,
                      ),
                    ),
                    labelStyle: TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                    labelText: '日付',
                    floatingLabelStyle: const TextStyle(fontSize: 12),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 1.0,
                      ),
                    ),
                  ),
                  onTap: () async {
                    // 日付選択ダイアログを表示
                    var date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2100),
                    );

                    // 日付が選択された場合(nullじゃない場合)、その日付をテキストフィールドに設定
                    if (date != null) {
                      String formattedDate = DateFormat('yyyy-MM-dd')
                          .format(date); // 日付を適切な形式にフォーマット
                      _datecontroller.text = formattedDate; // テキストフィールドに日付を設定
                    }
                  },
                  controller: _datecontroller,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '日付を入力してください';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: Colors.black,
                        width: 2.0,
                      ),
                    ),
                    labelStyle: TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                    labelText: '管理番号',
                    floatingLabelStyle: const TextStyle(fontSize: 12),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 1.0,
                      ),
                    ),
                  ),

                  keyboardType: TextInputType.emailAddress,

                  // 半角英数字のみに制限
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '管理番号を入力してください';
                    }
                    return null;
                  },
                  controller: _idController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: Colors.black,
                        width: 2.0,
                      ),
                    ),
                    labelStyle: TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                    labelText: 'ブランド',
                    floatingLabelStyle: const TextStyle(fontSize: 12),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 1.0,
                      ),
                    ),
                  ),
                  value: _selectedBrand.value,
                  items: brands.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    _selectedBrand.value = newValue;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'ブランドを選択してください';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: Colors.black,
                        width: 2.0,
                      ),
                    ),
                    labelStyle: TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                    labelText: '商品名',
                    floatingLabelStyle: const TextStyle(fontSize: 12),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 1.0,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '商品名を入力してください';
                    }
                    return null;
                  },
                  controller: _nameController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    suffixText: '円',
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: Colors.black,
                        width: 2.0,
                      ),
                    ),
                    labelStyle: TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                    labelText: '仕入れ価格',
                    floatingLabelStyle: const TextStyle(fontSize: 12),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 1.0,
                      ),
                    ),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '仕入れ価格を入力してください';
                    }
                    return null;
                  },
                  controller: _buyingPriceController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    suffixText: '円',
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: Colors.black,
                        width: 2.0,
                      ),
                    ),
                    labelStyle: TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                    labelText: '仕入れ時送料',
                    floatingLabelStyle: const TextStyle(fontSize: 12),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 1.0,
                      ),
                    ),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '仕入れ時の送料を入力してください';
                    }
                    return null;
                  },
                  controller: _otherCostsController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: Colors.black,
                        width: 2.0,
                      ),
                    ),
                    labelStyle: TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                    labelText: '仕入れ先',
                    floatingLabelStyle: const TextStyle(fontSize: 12),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 1.0,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '仕入れ先を入力してください';
                    }
                    return null;
                  },
                  controller: _supplierController,
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButtonFormField<InventoryStatus>(
                    value: InventoryStatus.notListed,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 2.0,
                        ),
                      ),
                      labelStyle: TextStyle(
                        fontSize: 15,
                        color: Colors.grey,
                      ),
                      labelText: '状態',
                      floatingLabelStyle: const TextStyle(fontSize: 12),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 1.0,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null) {
                        return '商品の状態を入力してください';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      _statusController.value = value;
                    },
                    items: InventoryStatus.values.map((InventoryStatus status) {
                      return DropdownMenuItem<InventoryStatus>(
                        value: status,
                        child: Text(inventoryStatusToJapanese(status)),
                        // child: Text(status.toString().split('.').last),
                      );
                    }).toList(),
                  )),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Color(0xFF222831)),
                ),
                onPressed: () async {
                  try {
                    if (_formKey.currentState!.validate()) {
                      // フォームが有効ならば何かを行う
                      // 例えば、データをサーバに送信するなど
                      // final user = FirebaseAuth.instance.currentUser!;

                      // final posterId = user.uid;
                      // final posterName = user.displayName!;
                      // final posterImageUrl = user.photoURL!;

                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text('在庫を追加しました')));

                      // String image = await uploadImage();

                      DateTime dateTime =
                          DateFormat('yyyy-MM-dd').parse(_datecontroller.text);

                      Timestamp timestamp = Timestamp.fromDate(dateTime);

                      final newDocumentReference = inventoriesReference.doc();

                      // FIrestoreに追加するデータ
                      Inventory newInventory = Inventory(
                        // image: image,
                        date: timestamp,
                        id: _idController.text,
                        brand: _selectedBrand.value!,
                        name: _nameController.text,
                        buyingPrice: double.parse(_buyingPriceController.text),
                        otherCosts: double.parse(_otherCostsController.text),
                        supplier: _supplierController.text,
                        reference: newDocumentReference,
                        status: _statusController.value!,
                      );

                      // Firestoreにデータを追加
                      await inventoriesReference.add(newInventory).then((_) {
                        // データの追加が成功したら前の画面に戻る
                        Navigator.pop(context);
                      });
                    } else {
                      throw Exception('フォーム入力をしてください。');
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('エラーが起きました: $e')));
                    // TextFormFieldの値をリセットする
                    _datecontroller.clear();
                    _idController.clear();
                    _selectedBrand.value = null;
                    _nameController.clear();
                    _buyingPriceController.clear();
                    _otherCostsController.clear();
                    _supplierController.clear();
                    _statusController.value = InventoryStatus.notListed;
                  }
                },
                child: Text('追加する'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
