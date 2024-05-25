import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// views_utils
import '../utils/page_title.dart';
import '../utils/colors.dart';
import '../utils/text_styles.dart';

// controllers
import '../../controllers/pages/home_page_controller.dart';
import '../../controllers/auth_controller.dart';

// ホーム画面用Widget
class MyPage extends ConsumerWidget {
  const MyPage({super.key});

  final String titleName = "マイページ";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ユーザを取得する．
    final user = ref.watch(authControllerProvider);
    final authController = ref.watch(authControllerProvider.notifier);
    //  //ユーザ名取得
    final String? currentUserName = authController.readUserName();

    return Scaffold(
      backgroundColor: CommonColors.pageBackgroundColor,
      appBar: AppBar(
        title: PageTitle(pageTitleName: titleName),
        backgroundColor: CommonColors.primaryColor,
        actions: <Widget>[
          IconButton(
              icon: const Icon(
                Icons.logout,
                color: CommonColors.subprimaryColor,
              ),
              // ログアウトする．
              onPressed: () => authController.logOut(context: context)),
        ],
      ),
      body: SingleChildScrollView(
          child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SingleChildScrollView(
                child: Text(
                    overflow: TextOverflow.ellipsis, "ユーザ名：$currentUserName")),
          ],
        ),
        Container(
            padding: const EdgeInsets.all(24), child: Text("ログイン情報: $user"))
      ])),
      // 下ボタン
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
