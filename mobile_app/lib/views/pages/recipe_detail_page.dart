import 'package:flutter/material.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:gap/gap.dart';
import 'package:hugeicons/hugeicons.dart';
// utils
import '../utils/page_title.dart';
import '../utils/colors.dart';
import '../utils/button_styles.dart';
import '../utils/text_styles.dart';

// pages
import "../../controllers/pages/recipe_detail_page_controller.dart";

// models
import '../../models/recipe_model.dart';

class RecipeDetailPage extends StatelessWidget {
  final Recipe recipe;
  final RecipeDetailPageController pageController;

  // コンストラクタ
  RecipeDetailPage({super.key, required this.recipe})
      : pageController = RecipeDetailPageController(recipe: recipe);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CommonColors.pageBackgroundColor,
        appBar: AppBar(
          title: PageTitle(pageTitleName: recipe.dishName ?? ""),
          backgroundColor: CommonColors.primaryColor,
        ),
        body: SingleChildScrollView(
            child: Center(
          child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                RecipeCard(recipe: recipe),
                const Gap(10),
                if (recipe.recipeType != "Original Recipe") ...{
                  ElevatedButton(
                    style: SettingPageButton.style,
                    child:
                        const Text('サイトページを表示', style: elevatedButtonTextStyle),
                    onPressed: () {
                      pageController.navigatorToRecipeSitePage(
                          context: context, recipeUrl: recipe.url ?? "");
                    },
                  )
                },
                // レシピのwebページを表示させるボタン
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
