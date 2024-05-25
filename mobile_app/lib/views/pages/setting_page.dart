import 'package:cook_helper_mobile_app/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

// views_utils
import '../utils/page_title.dart';
import '../utils/colors.dart';
import '../utils/text_styles.dart';
import "../utils/button_styles.dart";

// controllers
import "../../controllers/pages/setting_page_controller.dart";

class SettingPage extends ConsumerWidget {
  const SettingPage({super.key});
  final String titleName = "その他設定";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // authControllerProviderを通して，authControllerを読み込む．
    final AuthController? authController =
        ref.watch(authControllerProvider.notifier);

    return Scaffold(
        backgroundColor: CommonColors.pageBackgroundColor,
        appBar: AppBar(
          title: PageTitle(pageTitleName: titleName),
          backgroundColor: CommonColors.primaryColor,
        ),
        body: SettingPageBody(authController: authController!));
  }
}

class SettingPageBody extends StatefulWidget {
  final AuthController authController;
  const SettingPageBody({super.key, required this.authController});

  @override
  SettingPageBodyState createState() => SettingPageBodyState();
}

class SettingPageBodyState extends State<SettingPageBody> {
  // ログアウトボタン
  bool logOutButtonPressed = false;
  // 退会ボタン
  bool deleteButtonPressed = false;

  @override
  Widget build(BuildContext context) {
    return Container(
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
            onPressed: () async {
              setState(() {
                logOutButtonPressed = true;
              });
              await widget.authController.logOut(context: context);
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
              bool result =
                  await widget.authController.delete(context: context);
              print("$result");
            },
          ),
          const Gap(10),
          ElevatedButton(
            style: SettingPageButton.style,
            child: logOutButtonPressed
                ? const CircularProgressIndicator(
                    strokeWidth: 2.0, color: CommonColors.textColor)
                : const Text('ログアウト', style: elevatedButtonTextStyle),
            onPressed: () async {
              setState(() {
                logOutButtonPressed = true;
              });
              await widget.authController.logOut(context: context);
            },
          ),
        ],
      ),
    );
  }
}
