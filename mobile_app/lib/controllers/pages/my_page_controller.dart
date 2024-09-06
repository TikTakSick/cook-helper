import 'package:flutter/material.dart';

// pages
import '../../views/pages/my_page.dart';
import '../../views/pages/setting_page.dart';
import '../../views/pages/recipe_add_page.dart';
import '../../views/pages/recipe_detail_page.dart';

class MyPageController {
  // レシピが押された時の動作
  navigatorToRecipeDetailPage(
      {required context, required recipe, required uid}) async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      // return WebViewContainer(url: "https://flutter.dev");
      return RecipeDetailPage(recipe: recipe, uid: uid);
    }));
  }

  // ホーム画面の下位ボタンが押された時の動作．
  navigatorByBottomNavigationBarItem({required context, required index}) async {
    switch (index) {
      // レシピ追加ページに移る．
      case recipeAddPageValue:
        await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return const RecipeAddPage();
        }));
      // ホームページ更新
      case randomRecipePageValue:
        null;
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
