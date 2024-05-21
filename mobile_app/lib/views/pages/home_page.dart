import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../ui_settings/ui_colors.dart';
import '../ui_settings/ui_textstyles.dart';
import '../../controllers/pages/home_page_controller.dart';
import '../../controllers/user_controller.dart';

// ホーム画面用Widget
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  // userNameを元に，userNameを変更する．
  String getHomePageTitle({required currentUserName}) {
    if (currentUserName == "") {
      return "Home Page";
    }
    return "$currentUserNameさんのHome Page";
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final User? user = ref.watch(userProvider);
    final String currentUserName =
        ref.read(userProvider.notifier).readUserName();
    final String homePageTitle =
        getHomePageTitle(currentUserName: currentUserName);

    return Scaffold(
      backgroundColor: CommonColors.pageBackgroundColor,
      appBar: AppBar(
        title: Text(homePageTitle, style: pageTitleTextStyle),
        backgroundColor: CommonColors.primaryColor,
        actions: <Widget>[
          IconButton(
              icon: const Icon(
                Icons.logout,
                color: CommonColors.subprimaryColor,
              ),
              // ログアウトする．
              onPressed: () => HomePageController().logOut(context: context)),
        ],
      ),
      body: Center(
        child: Container(
            padding: const EdgeInsets.all(24), child: Text("ログイン情報：${user}")),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        // アイコン設定
        iconSize: 35,
        selectedIconTheme:
            const IconThemeData(color: CommonColors.subprimaryColor),
        unselectedIconTheme:
            const IconThemeData(color: CommonColors.subprimaryColor),
        // ラベルの色設定をここで行う（統一する）
        selectedItemColor: CommonColors.textColor,
        unselectedItemColor: CommonColors.textColor,
        // ラベルのTextstyle設定（fontSizeを統一させる）
        selectedLabelStyle: bottomNavigationBarItemLabelTextStyle,
        unselectedLabelStyle: bottomNavigationBarItemLabelTextStyle,
        // 背景色
        backgroundColor: CommonColors.primaryColor,
        items: const [
          BottomNavigationBarItem(label: "レシピ追加", icon: Icon(Icons.add)),
          BottomNavigationBarItem(label: "ホーム画面更新", icon: Icon(Icons.home)),
          BottomNavigationBarItem(label: "設定", icon: Icon(Icons.settings)),
        ],
        // タップされたボタンに応じて，画面遷移する．
        onTap: (index) {
          HomePageController().navigatorByBottomNavigationBarItem(
              context: context, index: index);
        },
      ),
    );
  }
}
