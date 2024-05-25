import 'package:flutter/material.dart';

// pages
import '../../views/pages/my_page.dart';
import '../../views/pages/setting_page.dart';
import '../../views/pages/recipe_add_page.dart';

class HomePageController {
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
