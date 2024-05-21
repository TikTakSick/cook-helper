import 'package:flutter/material.dart';

import '../../views/dialogs/updating_user_name_result_dialog.dart';

class SettingDialogController {
  // UpdatingUserNameDialogで行った操作（ユーザ名変更）の結果を返すダイアログ
  showUpdatingUserNameResultDialog({required context, required bool result}) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return UpdatingUserNameResultDialog(updatingUserNameResult: result);
        });
  }
}
