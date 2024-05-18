import 'package:flutter/material.dart';
import '../../views/dialogs/updating_user_name_dialog.dart';

class SettingPageController {
  // ユーザ名変更用のダイアログを表示する．
  showUpdatingUserNameDialog({required context}) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return UpdatingUserNameDialog();
        });
  }
}
