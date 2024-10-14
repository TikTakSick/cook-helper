import 'package:flutter/material.dart';
import 'dart:math';

// pages
import '../../views/pages/my_page.dart';
import '../../views/pages/setting_page.dart';
import '../../views/pages/recipe_add_page.dart';
import '../../views/pages/recipe_detail_page.dart';

// models
import '../../models/recipe_model.dart';

class MyPageController {
  //
  _getRecipeRandomlyFromRecipeList({required List<Recipe> recipeList}) {
    final int randomIndex = Random().nextInt(recipeList.length);
    return recipeList[randomIndex];
  }

  // レシピが押された時の動作
  navigatorToRecipeDetailPage(
      {required context, required recipe, required user}) async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      // return WebViewContainer(url: "https://flutter.dev");
      return RecipeDetailPage(recipe: recipe, user: user);
    }));
  }

  // ホーム画面の下位ボタンが押された時の動作．
  navigatorByBottomNavigationBarItem(
      {required context, required index, recipes, user}) async {
    switch (index) {
      // レシピ追加ページに移る．
      case recipeAddPageValue:
        await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return const RecipeAddPage();
        }));
      // ランダムにレシピを選び，レシピ詳細ページに移る．
      case randomRecipePageValue:
        // レシピリストを取得
        final List<Recipe> recipeList = recipes.value;
        if (recipeList.isEmpty) {
          debugPrint("レシピがありません．");
          return;
        }
        final Recipe recipe = _getRecipeRandomlyFromRecipeList(
          recipeList: recipeList,
        );
        navigatorToRecipeDetailPage(
          context: context,
          recipe: recipe,
          user: user,
        );
      // 設定ページに移る.
      case settingPageValue:
        await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return const SettingPage();
        }));
      default:
        print("想定していない操作です．");
    }
  }
}
