import 'package:flutter/material.dart';
import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

// views
import '../dialogs/add_recipe_to_firestore_result_dialog.dart';

// //utils
import '../utils/page_title.dart';
import '../utils/colors.dart';
import '../utils/text_styles.dart';
import "../utils/button_styles.dart";

// controllers
import '../../controllers/auth_controller.dart';
import '../../controllers/recipe_controller.dart';

// レシピ追加ページを実装している．

class RecipeAddPage extends ConsumerStatefulWidget {
  // UserProviderを呼び出す．
  const RecipeAddPage({super.key});
  final String titleName = "レシピ追加";

  @override
  RecipeAddPageState createState() => RecipeAddPageState();
}

class RecipeAddPageState extends ConsumerState<RecipeAddPage> {
  //選ばれたRadioボタンの値
  int _selectedValue = _notSelectedValue;

  // Radioボタンの値の種類
  static const int _notSelectedValue = 0; // 初期値 何も選択されてない
  static const int _originalRecipeValue = 1;
  static const int _webRecipe = 2;
  static const int _webRecipeAutoGeneratedByAI = 3;

  // レシピの種類Mapping
  static const Map<int, String> _recipeType = {
    _originalRecipeValue: "Original Recipe",
    _webRecipe: "Web Recipe",
    _webRecipeAutoGeneratedByAI: "Web Recipe Auto Generated By AI"
  };

  // Formキーの設定
  final _formKey = GlobalKey<FormState>();

  // レシピが登録されている最中かどうか
  bool isRegisteringRecipeToFirestore = false;

  // レシピ追加フォーム入力
  final dishNameController = TextEditingController();
  final ingredientsController = TextEditingController();
  final instructionsController = TextEditingController();
  final urlController = TextEditingController();
  final recipeTypeController = TextEditingController();

  // 表示されるフォームを変更する．
  void _changeForm({required int selectedValue}) {
    switch (selectedValue) {
      // オリジナルレシピ入力
      case _originalRecipeValue:
        urlController.text = "";
        recipeTypeController.text = _recipeType[selectedValue]!;
      // webサイトのレシピ手動入力
      case _webRecipe:
        recipeTypeController.text = _recipeType[selectedValue]!;
      // webサイトのレシピ（URLのみ）入力
      case _webRecipeAutoGeneratedByAI:
        dishNameController.text = "";
        ingredientsController.text = "";
        instructionsController.text = "";
        recipeTypeController.text = _recipeType[selectedValue]!;
    }
  }

  // 入力全てリセットする
  void _resetFormInput() {
    setState(() {
      _selectedValue = _notSelectedValue;
      dishNameController.text = "";
      ingredientsController.text = "";
      instructionsController.text = "";
      urlController.text = "";
      recipeTypeController.text = "";
    });
  }

  // RadioListTileのvalueを変更する．
  void _changeRadioValue(value) {
    setState(() {
      _selectedValue = value;
      // RaioListTileのvalueを変更に伴い，フォームも変更する．
      _changeForm(selectedValue: _selectedValue);
    });
  }

  // バリデーター
  // // 入力値がnullまたは空文字かチェックする．
  String? _validateInputHasText({required value}) {
    if (value == null || value.isEmpty) {
      return 'テキストを入力してください';
    }
    return null;
  }

  // // 入力値が適切なurlかどうかチェックする
  String? _validateInputIsValidURL({required urlValue}) {
    // 入力欄に何も入力されてない
    if (urlValue == null || urlValue.isEmpty) {
      return '何も入力されてません';
      // 入力されたURLが，適切な場合
    } else if (!Uri.parse(urlValue).isAbsolute ||
        !Uri.parse(urlValue).hasAbsolutePath) {
      return "不適切なURLです";
    }
    return null;
  }

  // // 全入力値が有効かどうか判断する
  bool _allInputsvalidated() {
    if (_selectedValue != _notSelectedValue &&
        _formKey.currentState!.validate()) {
      return true;
    }
    return false;
  }

  // Firestoreにレシピを追加する．
  bool _addRecipeToFirestore({required uid}) {
    RecipeController recipeController = RecipeController.setDbRef(uid);
    bool result = recipeController.addRecipeToFirestore(
      dishName: dishNameController.text,
      recipeType: recipeTypeController.text,
      ingredients: ingredientsController.text,
      instructions: instructionsController.text,
      url: urlController.text,
    );
    // レシピ追加の結果を返す．
    return result;
  }

  // 画面部分
  @override
  Widget build(BuildContext context) {
    // userIDを取得する．
    final String? uid = ref.read(authControllerProvider.notifier).readUserID();
    // ここにfirestoreのproviderを用意する．

    return Scaffold(
        backgroundColor: CommonColors.pageBackgroundColor,
        appBar: AppBar(
          title: PageTitle(pageTitleName: widget.titleName),
          backgroundColor: CommonColors.primaryColor,
        ),
        body: SingleChildScrollView(
            child: Column(
          children: [
            // 入力リセットボタン&入力形式の変更
            Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 入力リセットボタン
                            ElevatedButton(
                              style: RecipeAddPageButton.style,
                              child: const Text('入力全てリセットする',
                                  style: elevatedButtonTextStyle),
                              onPressed: () {
                                _resetFormInput();
                              },
                            ),
                          ])
                    ])),
            // 横線
            const Divider(
              color: CommonColors.primaryColor,
              thickness: 5,
            ),
            // 入力フォームとボタン
            Container(
                padding: const EdgeInsets.all(24),
                child: Form(
                    key: _formKey,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          // 入力形式の変更
                          RadioListTile(
                              title: const Text("オリジナルレシピ",
                                  style: radioListTileTextStyle),
                              activeColor: CommonColors.primaryColor,
                              value: _originalRecipeValue,
                              groupValue: _selectedValue,
                              onChanged: (value) => _changeRadioValue(value)),
                          RadioListTile(
                            title: const Text("Webサイトのレシピ（手動入力）",
                                style: radioListTileTextStyle),
                            activeColor: CommonColors.primaryColor,
                            value: _webRecipe,
                            groupValue: _selectedValue,
                            onChanged: (value) => _changeRadioValue(value),
                          ),
                          RadioListTile(
                            title: const Text("Webサイトのレシピ（URLのみ入力）",
                                style: radioListTileTextStyle),
                            subtitle: const Text(
                                "　生成AIがレシピを自動生成します。\n　内容の正当性は保証しません。"),
                            activeColor: CommonColors.primaryColor,
                            value: _webRecipeAutoGeneratedByAI,
                            groupValue: _selectedValue,
                            onChanged: (value) => _changeRadioValue(value),
                          ),
                          const Gap(10),
                          // ラジオボタン未入力時のエラーメッセージ
                          Container(
                              child: _selectedValue == _notSelectedValue
                                  ? const Text("ラジオボタンを選択してください",
                                      style: TextStyle(color: Colors.red))
                                  : const Text("")),
                          // 料理名フィールド
                          Visibility(
                            visible: _selectedValue == _originalRecipeValue ||
                                _selectedValue == _webRecipe,
                            child: AutoSizeTextFormField(
                              minLines: 1,
                              maxLines: 1,
                              controller: dishNameController,
                              decoration: const InputDecoration(
                                labelText: '料理名',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                return _validateInputHasText(value: value);
                              },
                            ),
                          ),
                          const Gap(10),
                          // 材料フィールド
                          Visibility(
                            visible: _selectedValue == _originalRecipeValue ||
                                _selectedValue == _webRecipe,
                            child: AutoSizeTextFormField(
                              minLines: 1,
                              maxLines: 20,
                              controller: ingredientsController,
                              decoration: const InputDecoration(
                                  labelText: '材料',
                                  isDense: true,
                                  border: OutlineInputBorder()),
                              validator: (value) {
                                return _validateInputHasText(value: value);
                              },
                            ),
                          ),
                          const Gap(10),
                          // 作り方フィールド
                          Visibility(
                            visible: _selectedValue == _originalRecipeValue ||
                                _selectedValue == _webRecipe,
                            child: AutoSizeTextFormField(
                              minLines: 1,
                              maxLines: 50,
                              controller: instructionsController,
                              decoration: const InputDecoration(
                                labelText: '作り方',
                                isDense: true,
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                return _validateInputHasText(value: value);
                              },
                            ),
                          ),
                          const Gap(10),
                          // URLフィールド
                          Visibility(
                            visible: _selectedValue == _webRecipe ||
                                _selectedValue == _webRecipeAutoGeneratedByAI,
                            child: AutoSizeTextFormField(
                              minLines: 1,
                              maxLines: 1,
                              controller: urlController,
                              decoration: const InputDecoration(
                                labelText: 'サイトURL',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                return _validateInputIsValidURL(
                                    urlValue: value);
                              },
                            ),
                          ),
                          const Gap(20),
                          // レシピ追加ボタン
                          ElevatedButton(
                            style: RecipeAddPageButton.style,
                            child: isRegisteringRecipeToFirestore
                                ? const CircularProgressIndicator(
                                    strokeWidth: 2.0,
                                    color: CommonColors.textColor)
                                : const Text('このレシピを追加する',
                                    style: elevatedButtonTextStyle),
                            onPressed: () async {
                              // 入力が有効な場合 → レシピ追加する．
                              if (_allInputsvalidated()) {
                                // isRegisteringRecipeToFirestoreをtrueにする．
                                setState(() {
                                  isRegisteringRecipeToFirestore = true;
                                });
                                // レシピ追加
                                bool addRecipeToFirestoreResult =
                                    _addRecipeToFirestore(uid: uid);

                                // 追加結果のダイアログ表示
                                await Future.delayed(const Duration(seconds: 1),
                                    () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AddRecipeToFirestoreResultDialog(
                                            addRecipeToFirestoreResult:
                                                addRecipeToFirestoreResult);
                                      });
                                });

                                // 追加成功した場合，入力全てリセットする
                                if (addRecipeToFirestoreResult == true) {
                                  _resetFormInput();
                                }

                                //レシピ登録が終了したので，isRegisteringRecipeToFirestoreをfalseにする．
                                setState(() {
                                  isRegisteringRecipeToFirestore = false;
                                });
                              }
                            },
                          ),
                          const Gap(10),
                        ])))
          ],
        )));
  }
}
