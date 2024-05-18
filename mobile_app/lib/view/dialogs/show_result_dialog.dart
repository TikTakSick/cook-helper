import 'package:flutter/material.dart';

import '../ui_settings/ui_colors.dart';
import '../ui_settings/ui_textstyles.dart';

// 何かしらのデータベースに対する操作の結果を表示するダイアログ
class ShowResultDialog extends StatelessWidget {
  final String topic;
  final bool result;

  // コンストラクタでtopicとresultをを受け取流．
  const ShowResultDialog(
      {super.key, required this.topic, required this.result});

  @override
  Widget build(BuildContext context) {
    bool success = result;
    Icon resultIcon = (success)
        ? const Icon(Icons.check, size: 40)
        : const Icon(Icons.error, size: 40);

    String resultMessage = (success) ? "成功" : "失敗";

    Text titleText = Text("$topic: $resultMessage",
        style: CommonTextStyle.dialogTitleTextStyle,
        textAlign: TextAlign.center);

    return AlertDialog(
        icon: resultIcon,
        surfaceTintColor: CommonColors.dialogBackgroundColor,
        backgroundColor: CommonColors.dialogBackgroundColor,
        title: titleText);
  }
}
