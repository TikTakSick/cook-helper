import 'package:flutter/material.dart';
import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

// views_utils
import '../utils/page_title.dart';
import '../utils/colors.dart';
import '../utils/text_styles.dart';
import "../utils/button_styles.dart";

// controllers
import '../../controllers/auth_controller.dart';

// レシピ追加ページを実装している．
// 以下二つの部分に分かれている．
// - RecipeAddPage：ページ本体
// - _RecipeAddPageBody：ページのbody部分

class RecipeAddPage extends ConsumerWidget {
  // UserProviderを呼び出す．
  const RecipeAddPage({super.key});
  final String titleName = "レシピ追加";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // userIDを取得する．
    final String? userID =
        ref.read(authControllerProvider.notifier).readUserID();
    // ここにfirestoreのproviderを用意する．

    return Scaffold(
        backgroundColor: CommonColors.pageBackgroundColor,
        appBar: AppBar(
          title: PageTitle(pageTitleName: titleName),
          backgroundColor: CommonColors.primaryColor,
        ),
        body: _RecipeAddPageBody(
          userID: userID!,
        ));
  }
}

class _RecipeAddPageBody extends StatefulWidget {
  final String userID;
  const _RecipeAddPageBody({required this.userID});

  @override
  _RecipeAddPageBodyState createState() => _RecipeAddPageBodyState();
}

class _RecipeAddPageBodyState extends State<_RecipeAddPageBody> {
  // Radioボタンの値の種類
  static const int _notSelectedValue = 0; // 初期値 何も選択されてない
  static const int _originalRecipeValue = 1;
  static const int _webRecipe = 2;
  static const int _webRecipeAutoGeneratedByAI = 3;

  //選ばれたRadioボタンの値
  int _selectedValue = _notSelectedValue;

  // レシピ追加ボタンが押されたかどうかを判定する．
  bool _buttonPressed = false;

  // Formキーの設定
  final _formKey = GlobalKey<FormState>();

  // レシピ追加フォーム入力
  final dishNameController = TextEditingController();
  final ingredientsController = TextEditingController();
  final instructionsController = TextEditingController();
  final urlController = TextEditingController();

  // レシピの種類
  static const Map<int, String> _recipeType = {
    _originalRecipeValue: "Original Recipe",
    _webRecipe: "Web Recipe",
    _webRecipeAutoGeneratedByAI: "Web Recipe Auto Generated by AI"
  };
  final recipeTypeController = TextEditingController();

  // 表示されるフォームを変更する．
  void _changeForm({required int selectedValue}) {
    switch (selectedValue) {
      // オリジナルレシピ入力
      case 1:
        urlController.text = "";
        recipeTypeController.text = _recipeType[selectedValue]!;
      // webサイトのレシピ手動入力
      case 2:
        recipeTypeController.text = _recipeType[selectedValue]!;
      // webサイトのレシピ（URLのみ）入力
      case 3:
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

  // RaioListTileのvalueを変更する．
  void _changeRadioValue(value) {
    setState(() {
      _selectedValue = value;
      // RaioListTileのvalueを変更に伴い，フォームも変更する．
      _changeForm(selectedValue: _selectedValue);
    });
  }

  // Firestoreにレシピを追加する．
  void _addRecipeToFirestore() {
    setState(() {
      _buttonPressed = _buttonPressed ^ true;
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                          subtitle:
                              const Text("・生成AIがレシピを自動生成します。\n内容の正当性は保証しません。"),
                          activeColor: CommonColors.primaryColor,
                          value: _webRecipeAutoGeneratedByAI,
                          groupValue: _selectedValue,
                          onChanged: (value) => _changeRadioValue(value),
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
                      // 料理名フィールド
                      SizedBox(
                        child: (_selectedValue == _originalRecipeValue ||
                                _selectedValue == _webRecipe)
                            ? AutoSizeTextFormField(
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
                              )
                            : null,
                      ),
                      const Gap(10),
                      // 材料フィールド
                      SizedBox(
                        child: (_selectedValue == _originalRecipeValue ||
                                _selectedValue == _webRecipe)
                            ? AutoSizeTextFormField(
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
                              )
                            : null,
                      ),
                      const Gap(10),
                      // 作り方フィールド
                      Container(
                        child: (_selectedValue == _originalRecipeValue ||
                                _selectedValue == _webRecipe)
                            ? AutoSizeTextFormField(
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
                                })
                            : null,
                      ),
                      const Gap(10),
                      // URLフィールド
                      Container(
                        child: (_selectedValue == _webRecipe ||
                                _selectedValue == _webRecipeAutoGeneratedByAI)
                            ? AutoSizeTextFormField(
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
                              )
                            : null,
                      ),
                      const Gap(20),
                      // レシピ追加ボタン
                      ElevatedButton(
                        style: RecipeAddPageButton.style,
                        child: _buttonPressed
                            ? const CircularProgressIndicator(
                                strokeWidth: 2.0, color: CommonColors.textColor)
                            : const Text('このレシピを追加する',
                                style: elevatedButtonTextStyle),
                        onPressed: () {
                          // フォームが有効な場合
                          if (_formKey.currentState!.validate()) {
                            // ScaffoldMessenger.of(context).showSnackBar(
                            //     const SnackBar(content: Text('データを処理中')));
                            _addRecipeToFirestore();
                          }
                        },
                      ),
                      const Gap(10),
                    ])))
      ],
    ));
  }
}
