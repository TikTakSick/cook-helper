import 'package:flutter/material.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:gap/gap.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hugeicons/hugeicons.dart';
// utils
import '../utils/page_title.dart';
import '../utils/colors.dart';
import '../utils/button_styles.dart';
import '../utils/text_styles.dart';

// pages
import "../../controllers/pages/recipe_detail_page_controller.dart";

// controllers
import '../../controllers/recipe_controller.dart';

// models
import '../../models/recipe_model.dart';

class RecipeDetailPage extends StatefulWidget {
  final Recipe recipe;
  final User user;

  // コンストラクタ
  const RecipeDetailPage({super.key, required this.recipe, required this.user});

  @override
  State<RecipeDetailPage> createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
  bool recipeDeleteButtonPushed = false;
  late RecipeDetailPageController recipePageController;

  @override
  void initState() {
    super.initState();
    recipePageController = RecipeDetailPageController(
      recipe: widget.recipe,
      user: widget.user,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CommonColors.pageBackgroundColor,
        appBar: AppBar(
          title: PageTitle(pageTitleName: widget.recipe.dishName ?? ""),
          backgroundColor: CommonColors.primaryColor,
        ),
        body: SingleChildScrollView(
            child: Center(
          child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                RecipeCard(recipe: widget.recipe),
                const Gap(10),
                // サイトページ表示ボタン
                if (widget.recipe.recipeType != "Original Recipe") ...{
                  ElevatedButton(
                    style: RecipeDetailPageButton.style,
                    child:
                        const Text('サイトページを表示', style: elevatedButtonTextStyle),
                    onPressed: () {
                      if (!context.mounted) {
                        return;
                      } else {
                        recipePageController.navigatorToRecipeSitePage(
                            context: context);
                      }
                    },
                  )
                },
                const Gap(10),
                // レシピ編集ボタン
                ElevatedButton(
                  style: RecipeDetailPageButton.style,
                  child: const Text('レシピを編集', style: elevatedButtonTextStyle),
                  onPressed: () {
                    recipePageController.navigatorToRecipeEditPage(
                        context: context);
                  },
                ),
                const Gap(10),
                // レシピ削除ボタン
                ElevatedButton(
                  style: RecipeDetailPageButton.style,
                  child: recipeDeleteButtonPushed
                      ? const CircularProgressIndicator(
                          strokeWidth: 2.0, color: CommonColors.textColor)
                      : const Text('このレシピを削除', style: elevatedButtonTextStyle),
                  onPressed: () {
                    setState(() {
                      recipeDeleteButtonPushed = true;
                    });
                    bool result = RecipeController(user: widget.user)
                        .deleteFromFirestore(
                            recipeId: widget.recipe.recipeId ?? "");
                    if (!context.mounted) {
                      return;
                    }
                    // ユーザ名変更捜査の結果を表示する．
                    Navigator.pop(context);
                    if (result) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('レシピを削除しました')));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('レシピ削除に失敗しました')));
                    }
                  },
                ),
                const Gap(100),
              ]),
        )));
  }
}

class RecipeCard extends StatelessWidget {
  final Recipe recipe;

  const RecipeCard({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      margin: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      color: recipeDetailColors,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: const Icon(
              Icons.restaurant_outlined,
              size: 40,
              color: CommonColors.subprimaryColor,
            ),
            tileColor: CommonColors.primaryColor,
            title: const Text(
              "料理名",
              style: recipeAttributeTextStyle,
            ),
            onTap: () {},
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              recipe.dishName ?? "",
              style: recipeDetailTextStyle,
            ),
          ),
          ListTile(
            leading: const Icon(
              HugeIcons.strokeRoundedVegetarianFood,
              color: CommonColors.subprimaryColor,
              size: 40,
            ),
            tileColor: CommonColors.primaryColor,
            title: const Text(
              "材料",
              style: recipeAttributeTextStyle,
            ),
            onTap: () {},
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              recipe.ingredients ?? "",
              style: recipeDetailTextStyle,
            ),
          ),
          ListTile(
            leading: const Icon(
              CommunityMaterialIcons.pot_mix_outline,
              size: 40,
              color: CommonColors.subprimaryColor,
            ),
            tileColor: CommonColors.primaryColor,
            title: const Text(
              "調理方法",
              style: recipeAttributeTextStyle,
            ),
            onTap: () {},
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              recipe.instructions ?? "",
              style: recipeDetailTextStyle,
            ),
          ),
        ],
      ),
    );
  }
}
