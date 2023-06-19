import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sales_management_app/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import 'inventory_class.dart';
import 'custom_widget/add_inventory_field.dart';

// フォームの状態を管理するためのキー
final _formKey = GlobalKey<FormState>();

// ブランド名のプルダウンリストの中身
// List<String> brands = ['LOUIS VUITTON', 'CHANEL', 'GUCCI', 'PRADA', 'HERMES'];
// final _selectedBrand = ValueNotifier<String?>(null);
// final _imageController = ValueNotifier<String?>(null);
// TextFormFieldに入力されるテキストを操作するためのWidget
// for getting the corrent text, updating the text, listening for change
TextEditingController _dateController = TextEditingController();
TextEditingController _idController = TextEditingController();
TextEditingController _nameController = TextEditingController();
TextEditingController _brandController = TextEditingController();
TextEditingController _buyingPriceController = TextEditingController();
TextEditingController _otherCostsController = TextEditingController();
TextEditingController _supplierController = TextEditingController();

TextEditingController _purchasedDateontroller = TextEditingController();
TextEditingController _sellingPriceController = TextEditingController();
TextEditingController _sellLocationController = TextEditingController();
TextEditingController _shippingCostsController = TextEditingController();
TextEditingController _salesDateController = TextEditingController();

// 画像選択コードに必要なコントローラーなど
// CollectionReference _reference =
//     FirebaseFirestore.instance.collection('shopping_list');

String imageUrl = '';
final _statusController =
    ValueNotifier<InventoryStatus?>(InventoryStatus.notListed);

// 在庫追加のためのクラス(設計図)の作成
// なぜStatefulWidgetがいいのかわかっていない(未解決)
class AddInventory extends ConsumerStatefulWidget {
  const AddInventory({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddInventoryState();
}

class _AddInventoryState extends ConsumerState<AddInventory> {
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
              IconButton(
                onPressed: () async {
                  // ステップ1 image_pickerを使って、画像を選択

                  ImagePicker imagePicker = ImagePicker();

                  // XFileは　クロスプラットフォームでファイルを扱うためのクラス
                  // Fileに比べて扱える機能が制限されている（クロスプラットフォームに合わせているため）
                  XFile? file =
                      await imagePicker.pickImage(source: ImageSource.gallery);
                  print('${file?.path}');

                  if (file == null) return;

                  // ファイル名として、現在日時をミリ秒に直して文字列で使う
                  // これで、一意にファイル名を指定することができる
                  String uniqueFileName =
                      DateTime.now().millisecondsSinceEpoch.toString();

                  // ステップ2 Firebase Storageに画像をアップロードする

                  Reference referenceRoot = FirebaseStorage.instance.ref();
                  Reference referenceDirImages = referenceRoot.child('images');

                  Reference referenceImageToUpload =
                      referenceDirImages.child(uniqueFileName);

                  try {
                    // 画像をアップロード
                    await referenceImageToUpload.putFile(File(file.path));

                    imageUrl = await referenceImageToUpload.getDownloadURL();
                  } catch (error) {
                    // エラーログを出力
                    print('Failed to upload image: $error');

                    // ユーザーへのフィードバック
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('画像のアップロードに失敗しました。')),
                    );
                  }
                },
                icon: Icon(Icons.camera_alt),
              ),
              CustomTextFormField(
                labelText: '日付',
                readOnly: true,
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
                    _dateController.text = formattedDate; // テキストフィールドに日付を設定
                  }
                },
                controller: _dateController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '日付を入力してください';
                  }
                  return null;
                },
              ),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: TextFormField(
              //     decoration: InputDecoration(
              //       focusedBorder: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(16),
              //         borderSide: const BorderSide(
              //           color: Colors.black,
              //           width: 2.0,
              //         ),
              //       ),
              //       labelStyle: TextStyle(
              //         fontSize: 15,
              //         color: Colors.grey,
              //       ),
              //       labelText: '管理番号',
              //       floatingLabelStyle: const TextStyle(fontSize: 12),
              //       enabledBorder: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(16),
              //         borderSide: BorderSide(
              //           color: Colors.black,
              //           width: 1.0,
              //         ),
              //       ),
              //     ),

              //     keyboardType: TextInputType.emailAddress,

              //     // 半角英数字のみに制限
              //     inputFormatters: [
              //       FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
              //     ],
              //     validator: (value) {
              //       if (value == null || value.isEmpty) {
              //         return '管理番号を入力してください';
              //       }
              //       return null;
              //     },
              //     controller: _idController,
              //   ),
              // ),
              CustomTextFormField(
                labelText: '管理番号',
                onTap: () {},
                controller: _idController,
                keyboardType: TextInputType.emailAddress,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]'))
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '管理番号を入力してください';
                  }
                  return null;
                },
              ),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: TextFormField(
              //     decoration: InputDecoration(
              //       focusedBorder: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(16),
              //         borderSide: const BorderSide(
              //           color: Colors.black,
              //           width: 2.0,
              //         ),
              //       ),
              //       labelStyle: TextStyle(
              //         fontSize: 15,
              //         color: Colors.grey,
              //       ),
              //       labelText: '管理番号',
              //       floatingLabelStyle: const TextStyle(fontSize: 12),
              //       enabledBorder: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(16),
              //         borderSide: BorderSide(
              //           color: Colors.black,
              //           width: 1.0,
              //         ),
              //       ),
              //     ),

              //     keyboardType: TextInputType.emailAddress,

              //     // 半角英数字のみに制限
              //     inputFormatters: [
              //       FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
              //     ],
              //     validator: (value) {
              //       if (value == null || value.isEmpty) {
              //         return '管理番号を入力してください';
              //       }
              //       return null;
              //     },
              //     controller: _idController,
              //   ),
              // ),
              CustomTextFormField(
                labelText: 'ブランド名',
                onTap: () {},
                controller: _brandController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'ブランド名を入力してください';
                  }
                  return null;
                },
              ),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: DropdownButtonFormField<String>(
              //     decoration: InputDecoration(
              //       focusedBorder: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(16),
              //         borderSide: const BorderSide(
              //           color: Colors.black,
              //           width: 2.0,
              //         ),
              //       ),
              //       labelStyle: TextStyle(
              //         fontSize: 15,
              //         color: Colors.grey,
              //       ),
              //       labelText: 'ブランド',
              //       floatingLabelStyle: const TextStyle(fontSize: 12),
              //       enabledBorder: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(16),
              //         borderSide: BorderSide(
              //           color: Colors.black,
              //           width: 1.0,
              //         ),
              //       ),
              //     ),
              //     value: _selectedBrand.value,
              //     items: brands.map<DropdownMenuItem<String>>((String value) {
              //       return DropdownMenuItem<String>(
              //         value: value,
              //         child: Text(value),
              //       );
              //   }).toList(),
              //   onChanged: (String? newValue) {
              //     _selectedBrand.value = newValue;
              //   },
              //   validator: (value) {
              //     if (value == null || value.isEmpty) {
              //       return 'ブランドを選択してください';
              //     }
              //     return null;
              //   },
              // ),
              CustomTextFormField(
                labelText: '商品名',
                onTap: () {},
                controller: _nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '商品名を入力してください';
                  }
                  return null;
                },
              ),

              CustomTextFormField(
                labelText: '仕入れ価格',
                suffixText: '円',
                onTap: () {},
                controller: _buyingPriceController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '仕入れ価格を入力してください';
                  }
                  return null;
                },
              ),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: TextFormField(
              //     decoration: InputDecoration(
              //       suffixText: '円',
              //       focusedBorder: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(16),
              //         borderSide: const BorderSide(
              //           color: Colors.black,
              //           width: 2.0,
              //         ),
              //       ),
              //       labelStyle: TextStyle(
              //         fontSize: 15,
              //         color: Colors.grey,
              //       ),
              //       labelText: '仕入れ価格',
              //       floatingLabelStyle: const TextStyle(fontSize: 12),
              //       enabledBorder: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(16),
              //         borderSide: BorderSide(
              //           color: Colors.black,
              //           width: 1.0,
              //         ),
              //       ),
              //     ),
              //     inputFormatters: [
              //       FilteringTextInputFormatter.digitsOnly,
              //     ],
              //     keyboardType: TextInputType.number,
              //     validator: (value) {
              //       if (value == null || value.isEmpty) {
              //         return '仕入れ価格を入力してください';
              //       }
              //       return null;
              //     },
              //     controller: _buyingPriceController,
              //   ),
              // ),
              CustomTextFormField(
                labelText: '仕入れ時送料',
                suffixText: '円',
                onTap: () {},
                controller: _otherCostsController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '仕入れ時送料を入力してください';
                  }
                  return null;
                },
              ),
              CustomTextFormField(
                labelText: '仕入先',
                onTap: () {},
                controller: _supplierController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '仕入先を入力してください';
                  }
                  return null;
                },
              ),
              CustomDropdownButtonFormField<InventoryStatus>(
                labelText: '状況',
                value: _statusController.value ?? InventoryStatus.notListed,
                items: InventoryStatus.values,
                onChanged: (InventoryStatus? newValue) {
                  if (newValue != null) {
                    _statusController.value = newValue;
                  }
                },
                validator: (InventoryStatus? value) {
                  if (value == null) {
                    return '商品の状況を入力してください';
                  }
                  return null;
                },
                displayText: inventoryStatusToJapanese,
              ),

              // CustomDropdownButtonFormField<InventoryStatus>(
              //   labelText: '状況',
              //   value: InventoryStatus.notListed,
              //   items: InventoryStatus.values,
              //   onChanged: (InventoryStatus? newValue) {
              //     if (newValue != null) {
              //       _statusController.value = newValue;
              //     }
              //   },
              //   validator: (InventoryStatus? value) {
              //     if (value == null) {
              //       return '商品の状況を入力してください';
              //     }
              //     return null;
              //   },
              //   displayText: inventoryStatusToJapanese,
              // ),

              // Padding(
              //     padding: const EdgeInsets.all(8.0),
              //     child: DropdownButtonFormField<InventoryStatus>(
              //       value: InventoryStatus.notListed,
              //       decoration: InputDecoration(
              //         focusedBorder: OutlineInputBorder(
              //           borderRadius: BorderRadius.circular(16),
              //           borderSide: const BorderSide(
              //             color: Colors.black,
              //             width: 2.0,
              //           ),
              //         ),
              //         labelStyle: TextStyle(
              //           fontSize: 15,
              //           color: Colors.grey,
              //         ),
              //         labelText: '状況',
              //         floatingLabelStyle: const TextStyle(fontSize: 12),
              //         enabledBorder: OutlineInputBorder(
              //           borderRadius: BorderRadius.circular(16),
              //           borderSide: BorderSide(
              //             color: Colors.black,
              //             width: 1.0,
              //           ),
              //         ),
              //       ),
              //       validator: (value) {
              //         if (value == null) {
              //           return '商品の状況を入力してください';
              //         }
              //         return null;
              //       },
              //       onChanged: (value) {
              //         _statusController.value = value;
              //       },
              //       items: InventoryStatus.values.map((InventoryStatus status) {
              //         return DropdownMenuItem<InventoryStatus>(
              //           value: status,
              //           child: Text(inventoryStatusToJapanese(status)),
              //           // child: Text(status.toString().split('.').last),
              //         );
              //       }).toList(),
              //     )),
              CustomTextFormField(
                labelText: '販売日時',
                readOnly: true,
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
                    _purchasedDateontroller.text =
                        formattedDate; // テキストフィールドに日付を設定
                  }
                },
                controller: _purchasedDateontroller,
                validator: (value) {
                  return null;
                },
              ),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: TextFormField(
              //     readOnly: true,
              //     decoration: InputDecoration(
              //       focusedBorder: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(16),
              //         borderSide: const BorderSide(
              //           color: Colors.black,
              //           width: 2.0,
              //         ),
              //       ),
              //       labelStyle: TextStyle(
              //         fontSize: 15,
              //         color: Colors.grey,
              //       ),
              //       labelText: '販売日付',
              //       floatingLabelStyle: const TextStyle(fontSize: 12),
              //       enabledBorder: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(16),
              //         borderSide: BorderSide(
              //           color: Colors.black,
              //           width: 1.0,
              //         ),
              //       ),
              //     ),
              //     onTap: () async {
              //       // 日付選択ダイアログを表示
              //       var date = await showDatePicker(
              //         context: context,
              //         initialDate: DateTime.now(),
              //         firstDate: DateTime(1900),
              //         lastDate: DateTime(2100),
              //       );

              // // 日付が選択された場合(nullじゃない場合)、その日付をテキストフィールドに設定
              // if (date != null) {
              //   String formattedDate = DateFormat('yyyy-MM-dd')
              //       .format(date); // 日付を適切な形式にフォーマット
              //   _purchasedDateontroller.text =
              //       formattedDate; // テキストフィールドに日付を設定
              // }
              //     },
              //     controller: _purchasedDateontroller,
              //     validator: (value) {
              //       return null;
              //     },
              //   ),
              // ),
              CustomTextFormField(
                labelText: '販売価格',
                suffixText: '円',
                onTap: () {},
                controller: _sellingPriceController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  return null;
                },
              ),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: TextFormField(
              //     decoration: InputDecoration(
              //       suffixText: '円',
              //       focusedBorder: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(16),
              //         borderSide: const BorderSide(
              //           color: Colors.black,
              //           width: 2.0,
              //         ),
              //       ),
              //       labelStyle: TextStyle(
              //         fontSize: 15,
              //         color: Colors.grey,
              //       ),
              //       labelText: '販売価格',
              //       floatingLabelStyle: const TextStyle(fontSize: 12),
              //       enabledBorder: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(16),
              //         borderSide: BorderSide(
              //           color: Colors.black,
              //           width: 1.0,
              //         ),
              //       ),
              //     ),
              //     inputFormatters: [
              //       FilteringTextInputFormatter.digitsOnly,
              //     ],
              //     keyboardType: TextInputType.number,
              //     validator: (value) {
              //       return null;
              //     },
              //     controller: _sellingPriceController,
              //   ),
              // ),
              CustomTextFormField(
                labelText: '販売場所',
                onTap: () {},
                controller: _sellLocationController,
                validator: (value) {
                  return null;
                },
              ),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: TextFormField(
              //     decoration: InputDecoration(
              //       focusedBorder: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(16),
              //         borderSide: const BorderSide(
              //           color: Colors.black,
              //           width: 2.0,
              //         ),
              //       ),
              //       labelStyle: TextStyle(
              //         fontSize: 15,
              //         color: Colors.grey,
              //       ),
              //       labelText: '販売場所',
              //       floatingLabelStyle: const TextStyle(fontSize: 12),
              //       enabledBorder: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(16),
              //         borderSide: BorderSide(
              //           color: Colors.black,
              //           width: 1.0,
              //         ),
              //       ),
              //     ),
              //     validator: (value) {
              //       return null;
              //     },
              //     controller: _sellLocationController,
              //   ),
              // ),
              CustomTextFormField(
                labelText: '送料',
                suffixText: '円',
                onTap: () {},
                controller: _shippingCostsController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  return null;
                },
              ),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: TextFormField(
              //     decoration: InputDecoration(
              //       suffixText: '円',
              //       focusedBorder: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(16),
              //         borderSide: const BorderSide(
              //           color: Colors.black,
              //           width: 2.0,
              //         ),
              //       ),
              //       labelStyle: TextStyle(
              //         fontSize: 15,
              //         color: Colors.grey,
              //       ),
              //       labelText: '送料',
              //       floatingLabelStyle: const TextStyle(fontSize: 12),
              //       enabledBorder: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(16),
              //         borderSide: BorderSide(
              //           color: Colors.black,
              //           width: 1.0,
              //         ),
              //       ),
              //     ),
              //     inputFormatters: [
              //       FilteringTextInputFormatter.digitsOnly,
              //     ],
              //     keyboardType: TextInputType.number,
              //     validator: (value) {
              //       return null;
              //     },
              //     controller: _shippingCostsController,
              //   ),
              // ),
              CustomTextFormField(
                labelText: '売上日時',
                readOnly: true,
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
                    _purchasedDateontroller.text =
                        formattedDate; // テキストフィールドに日付を設定
                  }
                },
                controller: _salesDateController,
                validator: (value) {
                  return null;
                },
              ),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: TextFormField(
              //     readOnly: true,
              //     decoration: InputDecoration(
              //       focusedBorder: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(16),
              //         borderSide: const BorderSide(
              //           color: Colors.black,
              //           width: 2.0,
              //         ),
              //       ),
              //       labelStyle: TextStyle(
              //         fontSize: 15,
              //         color: Colors.grey,
              //       ),
              //       labelText: '売上日付',
              //       floatingLabelStyle: const TextStyle(fontSize: 12),
              //       enabledBorder: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(16),
              //         borderSide: BorderSide(
              //           color: Colors.black,
              //           width: 1.0,
              //         ),
              //       ),
              //     ),
              //     onTap: () async {
              //       // 日付選択ダイアログを表示
              //       var date = await showDatePicker(
              //         context: context,
              //         initialDate: DateTime.now(),
              //         firstDate: DateTime(1900),
              //         lastDate: DateTime(2100),
              //       );

              //       // 日付が選択された場合(nullじゃない場合)、その日付をテキストフィールドに設定
              //       if (date != null) {
              //         String formattedDate = DateFormat('yyyy-MM-dd')
              //             .format(date); // 日付を適切な形式にフォーマット
              //         _salesDateController.text =
              //             formattedDate; // テキストフィールドに日付を設定
              //       }
              //     },
              //     controller: _salesDateController,
              //     validator: (value) {
              //       return null;
              //     },
              //   ),
              // ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Color(0xFF222831)),
                ),
                onPressed: () async {
                  try {
                    // double.parse()を安全にするためのnullチェック

                    double? sellingPrice =
                        _sellingPriceController.text.isNotEmpty
                            ? double.parse(_sellingPriceController.text)
                            : null;

                    double? shippingCost =
                        _shippingCostsController.text.isNotEmpty
                            ? double.parse(_shippingCostsController.text)
                            : null;
                    if (_formKey.currentState!.validate()) {
                      // フォームが有効ならば何かを行う
                      // 例えば、データをサーバに送信するなど

                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text('在庫を追加中です')));

                      // String image = await uploadImage();

                      DateTime dateTime =
                          DateFormat('yyyy-MM-dd').parse(_dateController.text);
                      // DateTime purchasedDateTime = DateFormat('yyyy-MM-dd')
                      //     .parse(_purchasedDateontroller.text);
                      // DateTime salesDateTime = DateFormat('yyyy-MM-dd')
                      //     .parse(_salesDateController.text);

                      DateTime? purchasedDateTime =
                          _purchasedDateontroller.text.isNotEmpty
                              ? DateFormat('yyyy-MM-dd')
                                  .parse(_purchasedDateontroller.text)
                              : null;

                      DateTime? salesDateTime =
                          _salesDateController.text.isNotEmpty
                              ? DateFormat('yyyy-MM-dd')
                                  .parse(_salesDateController.text)
                              : null;

                      Timestamp dateTimestamp = Timestamp.fromDate(dateTime);
                      // Timestamp purchasedDateTimestamp =
                      //     Timestamp.fromDate(purchasedDateTime);
                      // Timestamp salesDateTimestamp =
                      //     Timestamp.fromDate(salesDateTime);

                      Timestamp? purchasedDateTimestamp =
                          purchasedDateTime != null
                              ? Timestamp.fromDate(purchasedDateTime)
                              : null;

                      Timestamp? salesDateTimestamp = salesDateTime != null
                          ? Timestamp.fromDate(salesDateTime)
                          : null;

                      final newDocumentReference = inventoriesReference.doc();

                      // FIrestoreに追加するデータ
                      Inventory newInventory = Inventory(
                        imageUrl: imageUrl,
                        date: dateTimestamp,
                        id: _idController.text,
                        brand: _brandController.text,
                        name: _nameController.text,
                        buyingPrice: double.parse(_buyingPriceController.text),
                        otherCosts: double.parse(_otherCostsController.text),
                        supplier: _supplierController.text,
                        reference: newDocumentReference,
                        status: _statusController.value!,
                        inspection: false,
                        purchased: false,
                        purchasedDate: purchasedDateTimestamp,
                        selligPrice: sellingPrice,
                        // selligPrice: double.parse(_sellingPriceController.text),
                        sellLocation: _sellLocationController.text,
                        shippingCost: shippingCost,
                        // shippingCost:
                        //     double.parse(_shippingCostsController.text),
                        salesDate: salesDateTimestamp,
                        revenue: false,
                      );

                      // Firestoreにデータを追加
                      await inventoriesReference.add(newInventory).then((_) {
                        // データの追加が成功したら前の画面に戻る
                        Navigator.pop(context);
                        // TextFormFieldの値をリセットする
                        _dateController.clear();
                        _idController.clear();
                        // _selectedBrand.value = null;
                        _brandController.clear();
                        _nameController.clear();
                        _buyingPriceController.clear();
                        _otherCostsController.clear();
                        _supplierController.clear();
                        _purchasedDateontroller.clear();
                        _sellingPriceController.clear();
                        _sellLocationController.clear();
                        _shippingCostsController.clear();
                        _salesDateController.clear();
                        _statusController.value = InventoryStatus.notListed;
                      });
                    } else {
                      throw Exception('フォーム入力をしてください。');
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('エラーが起きました: $e')));
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
