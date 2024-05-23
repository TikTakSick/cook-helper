import 'package:cook_helper_mobile_app/controllers/user_controller.dart';
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
    // userProviderを通して，userControllerを読み込む．
    final UserController userController = ref.read(userProvider.notifier);

    return Scaffold(
        backgroundColor: CommonColors.pageBackgroundColor,
        appBar: AppBar(
          title: PageTitle(pageTitleName: titleName),
          backgroundColor: CommonColors.primaryColor,
        ),
        body: SettingPageBody(userController: userController));
  }
}

class SettingPageBody extends StatefulWidget {
  final UserController userController;
  const SettingPageBody({super.key, required this.userController});

  @override
  SettingPageBodyState createState() => SettingPageBodyState();
}

class SettingPageBodyState extends State<SettingPageBody> {
  bool logOutButtonPressed = false;
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
                await widget.userController.logOut(context: context);
              }),
        ],
      ),
    );
  }
}
