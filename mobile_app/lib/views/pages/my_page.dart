import 'package:flutter/material.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

// utils
import '../utils/page_title.dart';
import '../utils/colors.dart';
import '../utils/text_styles.dart';

// controllers
import '../../controllers/pages/my_page_controller.dart';
import '../../controllers/auth_controller.dart';

// models
import '../../models/recipe_model.dart';

// providers
import "../../providers/recipes_provider.dart";

// BottomeNavigationBarItemの設定
const recipeAddPageValue = 0;
const randomRecipePageValue = 1;
const settingPageValue = 2;

const Map<int, BottomNavigationBarItem> bottomNavigationBarItemMap = {
  recipeAddPageValue:
      BottomNavigationBarItem(label: "レシピ追加", icon: Icon(Icons.add)),
  randomRecipePageValue: BottomNavigationBarItem(
      label: "おまかせレシピ", icon: Icon(CommunityMaterialIcons.chef_hat)),
  settingPageValue:
      BottomNavigationBarItem(label: "設定", icon: Icon(Icons.settings)),
};

// マイページ画面用Widget
class MyPage extends ConsumerWidget {
  const MyPage({super.key});

  final String titleName = "マイページ";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ユーザを取得する．
    final user = ref.watch(authControllerProvider);
    final String? uid = user?.uid;
    final authController = ref.watch(authControllerProvider.notifier);
    //  //ユーザ名取得
    final String? currentUserName = authController.readUserName();

    // レシピリストを取得する．
    final recipes = ref.watch(recipeProvider(uid));

    // BottomNavigationBarItemのリスト
    List<BottomNavigationBarItem> bottomNavigationBarItemList =
        bottomNavigationBarItemMap.values.toList();

    return Scaffold(
      backgroundColor: CommonColors.pageBackgroundColor,
      appBar: AppBar(
        title: PageTitle(pageTitleName: titleName),
        backgroundColor: CommonColors.primaryColor,
        leading: IconButton(
          onPressed: () async {
            // ホーム画面更新
            await Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) {
                return const MyPage();
              }),
            );
          },
          icon: const Icon(
            Icons.food_bank,
            color: CommonColors.subprimaryColor,
            size: 40,
          ),
        ),
        actions: <Widget>[
          IconButton(
              icon: const Icon(
                Icons.logout,
                color: CommonColors.subprimaryColor,
                size: 40,
              ),
              // ログアウトする．
              onPressed: () => authController.logOut(context: context)),
        ],
      ),
      body: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Gap(10),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(children: [
              Text(overflow: TextOverflow.ellipsis, "ユーザ名：$currentUserName "),
              const Text("--上部ボタンの説明--"),
              const Gap(3),
              const Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                Icon(
                  Icons.food_bank,
                ),
                Text("：マイページ更新")
              ]),
              const Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                Icon(
                  Icons.logout,
                ),
                Text("：      ログアウト")
              ]),
              const Gap(3),
              const Text("---------------------"),
            ])
          ],
        ),
        Text("ログイン情報: $user"),
        const Gap(30),
        //レシピ表示部分．
        recipes.when(
          data: (recipes) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: recipes.length,
              itemBuilder: (context, index) {
                final recipe = recipes[index];
                return Column(children: [
                  const Divider(),
                  ListTile(
                    title: Text(
                      recipe.dishName ?? "",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(recipe.recipeType ?? ""),
                    leading: const CircleAvatar(
                      radius: 30,
                      backgroundColor: CommonColors.primaryColor,
                      child: Icon(
                        Icons.restaurant,
                        size: 40,
                        color: CommonColors.subprimaryColor,
                      ),
                    ),
                    onTap: () {
                      //レシピ詳細画面に遷移する．
                      HomePageController().navigatorToRecipeDetailPage(
                          context: context, recipe: recipe);
                    },
                  ),
                ]);
              },
            );
          },
          loading: () => const CircularProgressIndicator(),
          error: (error, stackTrace) => Text("Error: $error"),
        ),
        const Divider(),
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
        type: BottomNavigationBarType.fixed,
        backgroundColor: CommonColors.primaryColor,
        items: bottomNavigationBarItemList,
        // タップされたボタンに応じて，画面遷移する．
        onTap: (index) {
          HomePageController().navigatorByBottomNavigationBarItem(
              context: context, index: index);
        },
      ),
    );
  }
}
