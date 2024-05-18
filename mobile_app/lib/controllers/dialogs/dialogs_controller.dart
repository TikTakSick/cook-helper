import 'package:flutter/material.dart';

import '../../views/dialogs/show_result_dialog.dart';

class DialogController {
  // UpdatingUserNameDialogで行った操作（ユーザ名変更）の結果を返すダイアログ
  showUpdatingUserNameResultDialog({required context, required bool result}) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return ShowResultDialog(topic: "ユーザ名変更", result: result);
        });
  }
}
