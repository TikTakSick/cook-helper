import 'package:flutter/material.dart';

import '../../model/authuser_model.dart';
import '../../view/dialogs/show_result_dialog.dart';

class DialogController {
  final bool successs = true;
  final bool error = false;

  String getUserName() {
    String? userName = AuthUserModel().getUserName();
    if (userName == null) {
      return "";
    }
    return userName.toString();
  }

  bool updateUserName({required String userName}) {
    try {
      AuthUserModel().updateUserName(userName: userName);
      return successs;
    } catch (e) {
      print(e);
      return error;
    }
  }

  // UpdatingUserNameDialogで行った操作（ユーザ名変更）の結果を返すダイアログ
  showUpdatingUserNameResultDialog({required context, required bool result}) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return ShowResultDialog(topic: "ユーザ名変更", result: result);
        });
  }
}
