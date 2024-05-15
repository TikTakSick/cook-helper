import 'package:flutter/material.dart';

import '../ui_settings/ui_colors.dart';
import '../ui_settings/ui_textstyles.dart';

// 何かしらのデータベースに対する操作の結果を表示するダイアログ
class ShowResultDialog extends StatelessWidget {
  final String topic;
  final bool result;
  final bool success = true;

  // コンストラクタでtopicを受け取り、フィールドに代入する
  const ShowResultDialog(
      {super.key, required this.topic, required this.result});

  Text titleText({required String text}) {
    return Text(text,
        style: CommonTextStyle.dialogTitleTextStyle,
        textAlign: TextAlign.center);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      surfaceTintColor: CommonColors.pageBackgroundColor,
      backgroundColor: CommonColors.pageBackgroundColor,
      title: (result == success)
          ? titleText(text: "$topic:  成功")
          : titleText(text: "$topic:  失敗"),
    );
  }
}
