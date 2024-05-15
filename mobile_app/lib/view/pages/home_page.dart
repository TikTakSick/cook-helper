import 'package:cook_helper_mobile_app/view/pages/setting_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../ui_settings/ui_colors.dart';
import '../ui_settings/ui_textstyles.dart';
import '../../controller/pages/home_page_controller.dart';

// ホーム画面用Widget
class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final User user = FirebaseAuth.instance.currentUser!;
  String pageTitle = "";

  @override
  void initState() {
    super.initState();
    pageTitle = HomePageController().getHomePageTitle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CommonColors.pageBackgroundColor,
      appBar: AppBar(
        title: Text(pageTitle, style: CommonTextStyle.pageTitleTextStyle),
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
        iconSize: 30,
        currentIndex: 1,
        selectedItemColor: CommonColors.textColor,
        selectedLabelStyle:
            CommonTextStyle.bottomNavigationBarItemLabelTextStyle,
        unselectedItemColor: CommonColors.textColor,
        unselectedLabelStyle:
            CommonTextStyle.bottomNavigationBarItemLabelTextStyle,
        backgroundColor: CommonColors.primaryColor,
        items: const [
          BottomNavigationBarItem(
            label: "レシピ追加",
            icon: Icon(Icons.add, color: CommonColors.subprimaryColor),
          ),
          BottomNavigationBarItem(
            label: "ホーム画面更新",
            icon: Icon(Icons.home, color: CommonColors.subprimaryColor),
          ),
          BottomNavigationBarItem(
            label: "設定",
            icon: Icon(Icons.settings, color: CommonColors.subprimaryColor),
          ),
        ],
        onTap: (index) {
          // タップされたボタンに応じて，画面遷移する．
          HomePageController().navigatorByBottomNavigationBarItem(
              context: context, index: index);
        },
      ),
    );
  }
}
