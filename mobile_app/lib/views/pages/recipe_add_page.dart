import 'package:flutter/material.dart';
import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

// ui_settings
import '../ui_settings/ui_colors.dart';
import '../ui_settings/ui_textstyles.dart';
import "../ui_settings/ui_buttonstyles.dart";

// controllers
import '../../controllers/user_controller.dart';

class RecipeAddPage extends ConsumerWidget {
  // UserProviderを呼び出す．
  RecipeAddPage({super.key});
  final String title = "レシピ追加";

  final userNameController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // userID
    final String userID = ref.read(userProvider.notifier).readUserID();
    // ここにfirestoreのproviderを用意する．

    return Scaffold(
        backgroundColor: CommonColors.pageBackgroundColor,
        appBar: AppBar(
          title: Text(title, style: pageTitleTextStyle),
          backgroundColor: CommonColors.primaryColor,
        ),
        body: _RecipeAddPageBody(
          userID: userID,
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
  int _selectedValue = 0;

  // レシピ入力値
  final dishNameController = TextEditingController();
  final ingredientsController = TextEditingController();
  final instructionsController = TextEditingController();
  final urlController = TextEditingController();
  final recipeTypeController = TextEditingController();

  void _changeForm({required int formValue}) {
    switch (formValue) {
      // オリジナルレシピ入力
      case 1:
        urlController.text = "";
        recipeTypeController.text = "Original";
      // webサイトのレシピ手動入力
      case 2:
        recipeTypeController.text = "Web Recipe";
      // webサイトのレシピ（URLのみ）入力
      case 3:
        dishNameController.text = "";
        ingredientsController.text = "";
        instructionsController.text = "";
        urlController.text = "";
        recipeTypeController.text = "Web Recipe";
    }
  }

  void _resetAllForm() {
    setState(() {
      _selectedValue = 0;
      dishNameController.text = "";
      ingredientsController.text = "";
      instructionsController.text = "";
      urlController.text = "";
      recipeTypeController.text = "";
    });
  }

  void _changeRadioValue(value) {
    setState(() {
      _selectedValue = value;
      _changeForm(formValue: _selectedValue);
    });
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
                            _resetAllForm();
                          },
                        ),
                        // 入力形式の変更
                        RadioListTile(
                            title: const Text("オリジナルレシピ",
                                style: radioListTileTextStyle),
                            activeColor: CommonColors.primaryColor,
                            value: 1,
                            groupValue: _selectedValue,
                            onChanged: (value) => _changeRadioValue(value)),
                        RadioListTile(
                          title: const Text("Webサイトのレシピ（手動入力）",
                              style: radioListTileTextStyle),
                          activeColor: CommonColors.primaryColor,
                          value: 2,
                          groupValue: _selectedValue,
                          onChanged: (value) => _changeRadioValue(value),
                        ),
                        RadioListTile(
                          title: const Text("Webサイトのレシピ（URLのみ入力）",
                              style: radioListTileTextStyle),
                          activeColor: CommonColors.primaryColor,
                          value: 3,
                          groupValue: _selectedValue,
                          onChanged: (value) => _changeRadioValue(value),
                        )
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
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  // 料理名フィールド
                  SizedBox(
                    child: (_selectedValue == 1 || _selectedValue == 2)
                        ? AutoSizeTextField(
                            minLines: 1,
                            maxLines: 1,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(), hintText: "料理名"),
                            controller: dishNameController)
                        : null,
                  ),
                  const Gap(10),
                  // 材料フィールド
                  SizedBox(
                    child: (_selectedValue == 1 || _selectedValue == 2)
                        ? AutoSizeTextField(
                            minLines: 1,
                            maxLines: 20,
                            decoration: const InputDecoration(
                                isDense: true,
                                border: OutlineInputBorder(),
                                hintText: "材料"),
                            controller: ingredientsController)
                        : null,
                  ),
                  const Gap(10),
                  // 作り方フィールド
                  Container(
                    child: (_selectedValue == 1 || _selectedValue == 2)
                        ? AutoSizeTextField(
                            minLines: 1,
                            maxLines: 50,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(), hintText: "作り方"),
                            controller: instructionsController)
                        : null,
                  ),
                  const Gap(10),
                  // URLフィールド
                  Container(
                    child: (_selectedValue == 2 || _selectedValue == 3)
                        ? AutoSizeTextField(
                            minLines: 1,
                            maxLines: 1,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: "サイトURL"),
                            controller: urlController)
                        : null,
                  ),
                  const Gap(20),
                  ElevatedButton(
                    style: RecipeAddPageButton.style,
                    child: const Text('このレシピを追加する',
                        style: elevatedButtonTextStyle),
                    onPressed: () {},
                  ),
                  const Gap(10),
                ]))
      ],
    ));
  }
}
