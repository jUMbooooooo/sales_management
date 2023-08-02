import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sales_management_app/provider/inventory_provider.dart';

import '../inventory_class.dart';
import '../custom_widget/add_inventory_field.dart';

// フォームの状態を管理するためのキー
final _addFormKey = GlobalKey<FormState>();

// ブランド名のプルダウンリストの中身
// List<String> brands = ['LOUIS VUITTON', 'CHANEL', 'GUCCI', 'PRADA', 'HERMES'];
// final _selectedBrand = ValueNotifier<String?>(null);
// final _imageController = ValueNotifier<String?>(null);
// TextFormFieldに入力されるテキストを操作するためのWidget
// for getting the corrent text, updating the text, listening for change
String imageUrl = '';
TextEditingController _dateController = TextEditingController();
TextEditingController _idController = TextEditingController();
TextEditingController _nameController = TextEditingController();
TextEditingController _brandController = TextEditingController();
TextEditingController _buyingPriceController = TextEditingController();
TextEditingController _otherCostsController = TextEditingController();
TextEditingController _supplierController = TextEditingController();

final _statusController =
    ValueNotifier<InventoryStatus?>(InventoryStatus.notListed);

TextEditingController _purchasedDateontroller = TextEditingController();
TextEditingController _sellingPriceController = TextEditingController();
TextEditingController _sellLocationController = TextEditingController();
TextEditingController _shippingCostsController = TextEditingController();
TextEditingController _salesDateController = TextEditingController();

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
    final brandNames = ref.watch(brandNamesProvider);
    final supplierName = ref.watch(supplierNamesProvider);
    final locationName = ref.watch(locationNameProvider);
    final sellLocations = ref.watch(sellLocationsProvider);
    double? feeRate;

    // return MaterialApp
    // 新しい画面を作成するたびに改めて新しいMaterialAppを作成するのは適切ではない
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text("在庫追加"),
        backgroundColor: const Color(0xFF222831),
      ),
      //TextFormFieldにキーボードが重なった場合のエラーを防ぐ(スクロール可能にする)
      body: SingleChildScrollView(
        child: Form(
          key: _addFormKey,
          child: Column(
            children: <Widget>[
              imageUrl.isEmpty
                  ? IconButton(
                      onPressed: () async {
                        // ステップ1 image_pickerを使って、画像を選択

                        ImagePicker imagePicker = ImagePicker();

                        // XFileは　クロスプラットフォームでファイルを扱うためのクラス
                        // Fileに比べて扱える機能が制限されている（クロスプラットフォームに合わせているため）
                        XFile? file = await imagePicker.pickImage(
                          source: ImageSource.gallery,
                          maxWidth: 500,
                        );
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
                          setState(() {}); // ここでsetStateを呼び出すことでUIが更新されます。
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
                    )
                  : Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(bottom: 10.0),
                          child: Text(
                            '商品画像',
                            style: TextStyle(
                              fontSize: 16.0, // フォントサイズ
                              fontWeight: FontWeight.bold, // フォントウェイト
                              color: Colors.black, // テキスト色
                            ),
                          ),
                        ),
                        Image.network(
                          imageUrl,
                          width: 150.0,
                          height: 150.0,
                          fit: BoxFit.cover,
                        ),
                      ],
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
              // CustomTextFormField(
              //   labelText: '仕入先',
              //   onTap: () {},
              //   controller: _supplierController,
              //   validator: (value) {
              //     if (value == null || value.isEmpty) {
              //       return '仕入先を入力してください';
              //     }
              //     return null;
              //   },
              // ),
              supplierName.when(
                data: (supplierNames) {
                  return CustomDropdownButtonFormField<String>(
                    labelText: '仕入先',
                    value: _supplierController.text.isEmpty
                        ? null
                        : _supplierController.text, // <-- ここを修正,
                    items: supplierNames,
                    onChanged: (value) {
                      _supplierController.text = value ?? '';
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '仕入先を選択してください';
                      }
                      return null;
                    },
                    displayText: (value) => value,
                  );
                },
                loading: () => const CircularProgressIndicator(),
                error: (_, __) => const Text('仕入先の取得に失敗しました'),
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

              locationName.when(
                data: (locationNames) {
                  return sellLocations.when(
                    data: (sellLocations) {
                      return CustomDropdownButtonFormField<String>(
                        labelText: '販売場所',
                        value: _sellLocationController.text.isEmpty
                            ? null
                            : _sellLocationController.text,
                        items: locationNames,
                        onChanged: (value) {
                          _sellLocationController.text = value ?? '';
                          // 選択された販売場所に対応するSellLocationオブジェクトを探し、そのfeeRateを取得
                          final selectedLocation = sellLocations.firstWhere(
                              (location) => location.locationName == value);
                          setState(() {
                            feeRate = selectedLocation?.feeRate;
                          });
                          // feeRateをInventoryオブジェクトにセットする処理をここに書く
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '販売場所を選択してください';
                          }
                          return null;
                        },
                        displayText: (value) => value,
                      );
                    },
                    loading: () => const CircularProgressIndicator(),
                    error: (_, __) => const Text('販売場所の取得に失敗しました'),
                  );
                },
                loading: () => const CircularProgressIndicator(),
                error: (_, __) => const Text('販売場所の取得に失敗しました'),
              ),
              // CustomTextFormField(
              //   labelText: '販売場所',
              //   onTap: () {},
              //   controller: _sellLocationController,
              //   validator: (value) {
              //     return null;
              //   },
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
                  backgroundColor:
                      MaterialStateProperty.all<Color>(const Color(0xFF222831)),
                ),
                onPressed: () async {
                  try {
                    // double.parse()を安全にするためのnullチェック

                    print('sellLocations[$sellLocations]');

                    if (_addFormKey.currentState!.validate()) {
                      // フォームが有効ならば何かを行う
                      // 例えば、データをサーバに送信するなど

                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('在庫を追加中です')));
                      double? sellingPrice =
                          _sellingPriceController.text.isNotEmpty
                              ? double.parse(_sellingPriceController.text)
                              : null;

                      double? shippingCost =
                          _shippingCostsController.text.isNotEmpty
                              ? double.parse(_shippingCostsController.text)
                              : null;

                      // String image = await uploadImage();

                      DateTime dateTime =
                          DateFormat('yyyy-MM-dd').parse(_dateController.text);

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

                      Timestamp? purchasedDateTimestamp =
                          purchasedDateTime != null
                              ? Timestamp.fromDate(purchasedDateTime)
                              : null;

                      Timestamp? salesDateTimestamp = salesDateTime != null
                          ? Timestamp.fromDate(salesDateTime)
                          : null;

                      int? salesPeriod = salesDateTimestamp != null &&
                              purchasedDateTimestamp != null
                          ? (salesDateTimestamp.toDate())
                              .difference(purchasedDateTimestamp.toDate())
                              .inDays
                          : null;
                      double? depositAmount =
                          sellingPrice != null && shippingCost != null
                              ? sellingPrice + shippingCost
                              : null;
                      double? salesFee =
                          feeRate != null && depositAmount != null
                              ? feeRate! * depositAmount
                              : null;
                      double? profit = depositAmount != null && salesFee != null
                          ? depositAmount -
                              salesFee -
                              double.parse(_buyingPriceController.text) -
                              double.parse(_otherCostsController.text)
                          : null;
                      double? profitRatio =
                          profit != null && depositAmount != null
                              ? profit / depositAmount
                              : null;

                      final inventoriesReference =
                          ref.watch(inventoriesReferenceProvider);

                      final newDocumentReference = inventoriesReference?.doc();

                      print('feeRate[$feeRate]');
                      print('salesPeriod[$salesPeriod]');
                      print('depositAmount[$depositAmount]');
                      print('salesFee[$salesFee]');
                      print('profit[$profit]');
                      print('profitRatio[$profitRatio]');

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
                        reference:
                            newDocumentReference as DocumentReference<Object?>,
                        status: _statusController.value!,
                        inspection: false,
                        purchased: false,
                        purchasedDate: purchasedDateTimestamp,
                        salesPeriod: salesPeriod,
                        depositAmount: depositAmount,
                        feeRate: feeRate,
                        salesFee: salesFee,
                        profit: profit,
                        profitRatio: profitRatio,
                        sellingPrice: sellingPrice,
                        // selligPrice: double.parse(_sellingPriceController.text),
                        sellLocation: _sellLocationController.text,
                        shippingCost: shippingCost,
                        // shippingCost:
                        //     double.parse(_shippingCostsController.text),
                        salesDate: salesDateTimestamp,
                        revenue: false,
                      );

                      // Firestoreにデータを追加
                      await inventoriesReference?.add(newInventory).then((_) {
                        // データの追加が成功したら前の画面に戻る
                        Navigator.pop(context);
                        // TextFormFieldの値をリセットする
                        imageUrl = '';
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
                child: const Text('追加する'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
