import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../view/pages/home_page.dart';
import '../../view/pages/login_page.dart';
import '../../view/pages/setting_page.dart';
import "../../model/authuser_model.dart";

class HomePageController {
  // ページタイトルを取得
  String getHomePageTitle() {
    String? userName = AuthUserModel().getUserName();
    if (userName == null) {
      return "Home Page";
    }
    return "$userNameさんのHome Page";
  }

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

  // ホームページの下位ボタンが押された時の動作．
  navigatorByBottomNavigationBarItem({required context, required index}) async {
    switch (index) {
      case 0:
        print("hello0");
      case 1:
        // ホーム更新
        await Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) {
            return HomePage();
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
