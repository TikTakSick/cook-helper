import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

// pages
import '../../views/pages/my_page.dart';
import '../../views/pages/login_page.dart';
import '../../views/pages/setting_page.dart';
import '../../views/pages/recipe_add_page.dart';

class HomePageController {
  // ログアウト時の動作
  logOut({required context}) async {
    await FirebaseAuth.instance.signOut();
    // ログイン画面に遷移，ホーム画面を破棄
    await Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) {
        return const LoginPage();
      }),
    );
  }

  // ホーム画面の下位ボタンが押された時の動作．
  navigatorByBottomNavigationBarItem({required context, required index}) async {
    switch (index) {
      case 0:
        // レシピ追加ページに移る．
        await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return const RecipeAddPage();
        }));
      case 1:
        // ホームページ更新
        await Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) {
            return const MyPage();
          }),
        );
      case 2:
        // 設定ページに移る.
        await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return const SettingPage();
        }));
      default:
        print("想定していない操作です．");
    }
  }
}
