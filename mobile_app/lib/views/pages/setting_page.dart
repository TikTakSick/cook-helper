import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// views_utils
import '../utils/page_title.dart';
import '../utils/colors.dart';
import '../utils/text_styles.dart';
import "../utils/button_styles.dart";

// controllers
import "../../controllers/pages/setting_page_controller.dart";
import '../../controllers/auth_controller.dart';

// providers
import '../../providers/shared_recipe_url_provider.dart';

class SettingPage extends ConsumerStatefulWidget {
  const SettingPage({super.key});
  final String titleName = "その他設定";

  @override
  SettingPageState createState() => SettingPageState();
}

class SettingPageState extends ConsumerState<SettingPage> {
  // ログアウトボタン
  bool logOutButtonPressed = false;
  // 退会ボタン
  bool deleteButtonPressed = false;

  @override
  Widget build(BuildContext context) {
    // authControllerProviderを通して，authControllerを読み込む．
    final authController = AuthController();

    return Scaffold(
        backgroundColor: CommonColors.pageBackgroundColor,
        appBar: AppBar(
          title: PageTitle(pageTitleName: widget.titleName),
          backgroundColor: CommonColors.primaryColor,
        ),
        body: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const Gap(20),
              // ユーザ名変更
              ElevatedButton(
                style: SettingPageButton.style,
                child: const Text('ユーザ名変更', style: elevatedButtonTextStyle),
                onPressed: () {
                  SettingPageController()
                      .showUpdatingUserNameDialog(context: context);
                },
              ),
              const Gap(10),
              // ログアウト
              ElevatedButton(
                style: SettingPageButton.style,
                child: logOutButtonPressed
                    ? const CircularProgressIndicator(
                        strokeWidth: 2.0, color: CommonColors.textColor)
                    : const Text('ログアウト', style: elevatedButtonTextStyle),
                onPressed: () {
                  setState(() {
                    logOutButtonPressed = true;
                  });
                  authController.logOut();
                  if (mounted) {
                    ref.read(sharedRecipeUrlProvider.notifier).clear();
                    context.go('/login-page');
                  }
                },
              ),
              const Gap(10),
              // 退会
              ElevatedButton(
                style: SettingPageButton.style,
                child: deleteButtonPressed
                    ? const CircularProgressIndicator(
                        strokeWidth: 2.0, color: CommonColors.textColor)
                    : const Text('退会', style: elevatedButtonTextStyle),
                onPressed: () async {
                  setState(() {
                    deleteButtonPressed = true;
                  });
                  final response = await authController.delete();
                  if (response["isSuccess"]) {
                    if (!context.mounted) return;
                    ref.read(sharedRecipeUrlProvider.notifier).clear();
                    context.go('/login-page');
                  }
                  debugPrint(response["errorMessage"]);
                },
              ),
              const Gap(10),
            ],
          ),
        ));
  }
}
