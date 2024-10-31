import 'package:flutter/material.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

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
import '../../providers/auth_provider.dart';
import '../../providers/shared_recipe_url_provider.dart';

// マイページ画面用Widget
class MyPage extends ConsumerWidget {
  const MyPage({super.key});

  final String titleName = "マイページ";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ユーザ情報取得
    final User? user = ref.watch(authUserProvider);
    final String? uid = user?.uid;
    final String? currentUserName = user?.displayName;

    // 登録レシピ情報取得
    final recipes = ref.watch(recipesProvider(uid));

    // myPageController
    final myPageController = MyPageController();
    final authController = AuthController();

    return Scaffold(
      backgroundColor: CommonColors.pageBackgroundColor,
      appBar: AppBar(
        title: PageTitle(pageTitleName: titleName),
        backgroundColor: CommonColors.primaryColor,
        leading: IconButton(
          onPressed: () {
            ref.refresh(authUserProvider);
            ref.refresh(recipesProvider(uid));
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
            onPressed: () async {
              final response = await authController.logOut();
              if (!response["isSuccess"]) {
                return;
              } else if (!context.mounted) {
                return;
              }
              ref.read(sharedRecipeUrlProvider.notifier).clear();
              context.go('/login-page');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        controller: ScrollController(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Gap(10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Gap(20),
                    Text(
                        overflow: TextOverflow.ellipsis,
                        "ユーザ名：$currentUserName ",
                        style: myPageTextStyle),
                  ],
                ),
                const Gap(3),
                const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Gap(20),
                      Icon(
                        size: 30,
                        Icons.food_bank,
                      ),
                      Text("：マイページ更新", style: myPageTextStyle)
                    ]),
                const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Gap(20),
                      Icon(
                        size: 30,
                        Icons.logout,
                      ),
                      Text("：ログアウト", style: myPageTextStyle)
                    ]),
                const Gap(3),
              ],
            ),
            const Gap(10),
            const Divider(),
            ListTile(
              title: const Text(
                "今日の献立を提案します",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              minVerticalPadding: 20,
              subtitle: const Text("登録済みのレシピからランダムに提案します"),
              leading: const CircleAvatar(
                radius: 30,
                backgroundColor: CommonColors.primaryColor,
                child: Icon(
                  CommunityMaterialIcons.chef_hat,
                  size: 40,
                  color: CommonColors.subprimaryColor,
                ),
              ),
              onTap: () {
                myPageController.navigatorToRecipeDetailPageRandomly(
                    context: context, user: user, recipes: recipes);
              },
            ),
            const Divider(),
            const Gap(20),
            const Text("↓登録済みのレシピ一覧↓", style: myPageTextStyle),
            //レシピ表示部分．
            recipes.when(
              data: (recipes) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: recipes.length,
                  itemBuilder: (context, index) {
                    final Recipe recipe = recipes[index];
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
                          myPageController.navigatorToRecipeDetailPage(
                              context: context, recipe: recipe, user: user);
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
            const Gap(100),
          ],
        ),
      ),
    );
  }
}
