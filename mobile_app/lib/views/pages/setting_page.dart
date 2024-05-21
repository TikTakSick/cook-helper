import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../ui_settings/ui_colors.dart';
import '../ui_settings/ui_textstyles.dart';
import "../ui_settings/ui_buttonstyles.dart";
import "../../controllers/pages/setting_page_controller.dart";

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});
  final String title = "Setting Page";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CommonColors.pageBackgroundColor,
        appBar: AppBar(
          title: Text(title, style: pageTitleTextStyle),
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
              )
            ],
          ),
        ));
  }
}
