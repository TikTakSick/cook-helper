import 'package:flutter/material.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:go_router/go_router.dart';

// views_utils
import 'utils/colors.dart';
import 'utils/text_styles.dart';

// BottomeNavigationBarItemの値
const recipeAddPageValue = 0;
const myPageValue = 1;
const settingPageValue = 2;
const randomRecipePageValue = 3;

// BottomNavigationBarItemの設定
const Map<int, BottomNavigationBarItem> bottomNavigationBarItemMap = {
  recipeAddPageValue: BottomNavigationBarItem(
    label: "レシピ追加",
    icon: Icon(Icons.add),
  ),
  myPageValue: BottomNavigationBarItem(icon: Icon(Icons.home), label: "マイページ"),
  settingPageValue:
      BottomNavigationBarItem(label: "設定", icon: Icon(Icons.settings)),
};

// NavigationBar
class MyAppBottomNavigationBar extends StatelessWidget {
  const MyAppBottomNavigationBar({super.key, required this.child});
  final Widget child;

  void navigatorByBottomNavigationBarItem(
      {required BuildContext context, required int index}) {
    switch (index) {
      // レシピ追加ページに移る．
      case recipeAddPageValue:
        context.go('/recipe-add-page');
      // マイページに移る．
      case myPageValue:
        context.go('/my-page');
      // 設定ページに移る.
      case settingPageValue:
        context.go('/setting-page');
      default:
        debugPrint("想定していない操作です．");
    }
  }

  static int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/recipe-add-page')) {
      return recipeAddPageValue;
    }
    if (location.startsWith('/my-page')) {
      return myPageValue;
    }
    if (location.startsWith('/setting-page')) {
      return settingPageValue;
    }
    return myPageValue;
  }

  @override
  Widget build(BuildContext context) {
    final List<BottomNavigationBarItem> bottomNavigationBarItemList =
        bottomNavigationBarItemMap.values.toList();

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _calculateSelectedIndex(context),
        // アイコン設定
        iconSize: 35,
        selectedIconTheme:
            const IconThemeData(color: CommonColors.selectedIconColor),
        unselectedIconTheme:
            const IconThemeData(color: CommonColors.unSelectedIconColor),
        // ラベルの色設定をここで行う（統一する）
        selectedItemColor: CommonColors.textColor,
        unselectedItemColor: CommonColors.textColor,
        // ラベルのTextstyle設定（fontSizeを統一させる）
        selectedLabelStyle: bottomNavigationBarItemLabelTextStyle,
        unselectedLabelStyle: bottomNavigationBarItemLabelTextStyle,
        // 背景色
        type: BottomNavigationBarType.fixed,
        backgroundColor: CommonColors.primaryColor,
        items: bottomNavigationBarItemList,
        // タップされたボタンに応じて，画面遷移する．
        onTap: (index) {
          navigatorByBottomNavigationBarItem(
            context: context,
            index: index,
          );
        },
      ),
    );
  }
}
