// 編集したい在庫のドキュメントIDを持つ新しいStatefulWidgetを作成
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_management_app/provider/inventory_provider.dart';
import '../custom_widget/add_inventory_field.dart';
import '../inventory_class.dart';

// フォームの状態を管理するためのキー
final _editFormKey = GlobalKey<FormState>();

class EditInventory extends ConsumerStatefulWidget {
  final String inventoryId; // 編集する在庫のドキュメントID

  const EditInventory({required this.inventoryId, Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditInventoryState();
}

class _EditInventoryState extends ConsumerState<EditInventory> {
  late String imageUrl;
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _buyingPriceController = TextEditingController();
  final TextEditingController _otherCostsController = TextEditingController();
  final TextEditingController _supplierController = TextEditingController();

  final _statusController =
      ValueNotifier<InventoryStatus?>(InventoryStatus.notListed);

  final TextEditingController _purchasedDateontroller = TextEditingController();
  final TextEditingController _sellingPriceController = TextEditingController();
  final TextEditingController _sellLocationController = TextEditingController();
  final TextEditingController _shippingCostsController =
      TextEditingController();
  final TextEditingController _salesDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchAndSetData(); // データを取得してTextEditingControllerにセットする
  }

  Future<void> fetchAndSetData() async {
    try {
      final userId = ref.watch(userIdProvider);

      DocumentSnapshot<Map<String, dynamic>> doc =
          await FirebaseFirestore.instance
              .collection('users') // usersコレクション
              .doc(userId) // 特定のユーザーのドキュメントID
              .collection('inventories') // 特定のユーザーの在庫サブコレクション
              .doc(widget.inventoryId) // 編集する在庫のドキュメントID
              .get(); // ドキュメントを取得

      print('[$doc]');

      // データが存在しない場合はエラー
      if (!doc.exists) {
        throw Exception('データが見つかりません');
      }

      // inventoryインスタンスの作成
      Inventory inventory = Inventory.fromFirestore(doc);

      imageUrl = inventory.imageUrl;
      // 日付形式を用いて Timestamp を String に変換します
      String purchasedDateStr = inventory.purchasedDate != null
          ? DateFormat('yyyy-MM-dd').format(inventory.purchasedDate!.toDate())
          : '';
      String salesDateStr = inventory.salesDate != null
          ? DateFormat('yyyy-MM-dd').format(inventory.salesDate!.toDate())
          : '';
      _dateController.text =
          DateFormat('yyyy-MM-dd').format(inventory.date.toDate());

      _idController.text = inventory.id;
      _brandController.text = inventory.brand;
      _nameController.text = inventory.name;
      _buyingPriceController.text = inventory.buyingPrice.toInt().toString();
      _otherCostsController.text = inventory.otherCosts.toInt().toString();
      _supplierController.text = inventory.supplier;
      _statusController.value = inventory.status;

      _purchasedDateontroller.text = purchasedDateStr;
      _sellingPriceController.text =
          inventory.selligPrice?.toInt().toString() ?? '';
      _sellLocationController.text = inventory.sellLocation ?? '';
      _shippingCostsController.text =
          inventory.shippingCost?.toInt().toString() ?? '';
      _salesDateController.text = salesDateStr;

      print('[status{${_statusController.value}}]');
    } catch (e) {
      print('エラーが起きました: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final brandNames = ref.watch(brandNamesProvider);

    return FutureBuilder<void>(
      future: fetchAndSetData(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.error != null) {
          return const Center(child: Text('エラーが発生しました'));
        } else {
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: true,
              title: const Text("在庫編集"),
              backgroundColor: const Color(0xFF222831),
            ),
            body: SingleChildScrollView(
              child: Form(
                key: _editFormKey,
                child: Column(
                  children: <Widget>[
                    IconButton(
                      onPressed: () async {
                        // ステップ1 image_pickerを使って、画像を選択

                        ImagePicker imagePicker = ImagePicker();

                        // XFileは　クロスプラットフォームでファイルを扱うためのクラス
                        // Fileに比べて扱える機能が制限されている（クロスプラットフォームに合わせているため）
                        XFile? file = await imagePicker.pickImage(
                            source: ImageSource.gallery);
                        print('${file?.path}');

                        if (file == null) return;

                        // ファイル名として、現在日時をミリ秒に直して文字列で使う
                        // これで、一意にファイル名を指定することができる
                        String uniqueFileName =
                            DateTime.now().millisecondsSinceEpoch.toString();

                        // ステップ2 Firebase Storageに画像をアップロードする

                        Reference referenceRoot =
                            FirebaseStorage.instance.ref();
                        Reference referenceDirImages =
                            referenceRoot.child('images');

                        Reference referenceImageToUpload =
                            referenceDirImages.child(uniqueFileName);

                        try {
                          // 画像をアップロード
                          await referenceImageToUpload.putFile(File(file.path));

                          imageUrl =
                              await referenceImageToUpload.getDownloadURL();
                        } catch (error) {
                          // エラーログを出力
                          print('Failed to upload image: $error');

                          // ユーザーへのフィードバック
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('画像のアップロードに失敗しました。')),
                          );
                        }
                      },
                      icon: const Icon(Icons.camera_alt),
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
                          _dateController.text =
                              formattedDate; // テキストフィールドに日付を設定
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
                    CustomTextFormField(
                      labelText: '管理番号',
                      onTap: () {},
                      controller: _idController,
                      keyboardType: TextInputType.emailAddress,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z0-9]'))
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '管理番号を入力してください';
                        }
                        return null;
                      },
                    ),
                    // CustomTextFormField(
                    //   labelText: 'ブランド名',
                    //   onTap: () {},
                    //   controller: _brandController,
                    //   validator: (value) {
                    //     if (value == null || value.isEmpty) {
                    //       return 'ブランド名を入力してください';
                    //     }
                    //     return null;
                    //   },
                    // ),
                    brandNames.when(
                      data: (brands) {
                        return CustomDropdownButtonFormField<String>(
                          labelText: 'ブランド名',
                          value: _brandController.text.isEmpty
                              ? null
                              : _brandController.text, // <-- ここを修正
                          items: brands,
                          onChanged: (value) {
                            _brandController.text = value ?? '';
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'ブランド名を選択してください';
                            }
                            return null;
                          },
                          displayText: (value) => value,
                        );
                      },
                      loading: () => const CircularProgressIndicator(),
                      error: (_, __) => const Text('ブランド名の取得に失敗しました'),
                    ),
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
                      value:
                          _statusController.value ?? InventoryStatus.notListed,
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
                    CustomTextFormField(
                      labelText: '販売場所',
                      onTap: () {},
                      controller: _sellLocationController,
                      validator: (value) {
                        return null;
                      },
                    ),
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
                          _salesDateController.text =
                              formattedDate; // テキストフィールドに日付を設定
                        }
                      },
                      controller: _salesDateController,
                      validator: (value) {
                        return null;
                      },
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color(0xFF222831)),
                      ),
                      onPressed: () async {
                        try {
                          if (_editFormKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('在庫を更新中です')));
                            double? sellingPrice =
                                _sellingPriceController.text.isNotEmpty
                                    ? double.parse(_sellingPriceController.text)
                                    : null;

                            double? shippingCost = _shippingCostsController
                                    .text.isNotEmpty
                                ? double.parse(_shippingCostsController.text)
                                : null;

                            DateTime dateTime = DateFormat('yyyy-MM-dd')
                                .parse(_dateController.text);

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

                            Timestamp dateTimestamp =
                                Timestamp.fromDate(dateTime);

                            Timestamp? purchasedDateTimestamp =
                                purchasedDateTime != null
                                    ? Timestamp.fromDate(purchasedDateTime)
                                    : null;

                            Timestamp? salesDateTimestamp =
                                salesDateTime != null
                                    ? Timestamp.fromDate(salesDateTime)
                                    : null;

                            final inventoriesReference =
                                ref.watch(inventoriesReferenceProvider);

                            final editDocumentReference =
                                inventoriesReference?.doc();

                            // InventoryクラスのインスタンスupdateInventoryを作成
                            Inventory updatedInventory = Inventory(
                              //コンストラクタ
                              imageUrl: imageUrl,
                              date: dateTimestamp,
                              id: _idController.text,
                              brand: _brandController.text,
                              name: _nameController.text,
                              buyingPrice:
                                  double.parse(_buyingPriceController.text),
                              otherCosts:
                                  double.parse(_otherCostsController.text),
                              supplier: _supplierController.text,
                              reference: editDocumentReference
                                  as DocumentReference<Object?>,
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
                              //コンストラクタ
                            );

                            // Firestoreのドキュメントを更新

                            await inventoriesReference!
                                .doc(widget.inventoryId)
                                .set(updatedInventory, SetOptions(merge: true))
                                .then((_) {
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
                              _statusController.value =
                                  InventoryStatus.notListed;
                            });
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('エラーが起きました: $e')));
                        }
                      },
                      child: const Text('編集'),
                    )
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
