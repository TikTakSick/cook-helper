import 'package:cook_helper_mobile_app/view/ui_settings/ui_colors.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../ui_settings/ui_textstyles.dart';
import '../ui_settings/ui_buttonstyles.dart';
import '../../controller/dialogs/dialogs_controller.dart';

class UpdatingUserNameDialog extends StatefulWidget {
  UpdatingUserNameDialog({Key? key}) : super(key: key);

  @override
  _UpdatingUserNameDialogState createState() => _UpdatingUserNameDialogState();
}

class _UpdatingUserNameDialogState extends State<UpdatingUserNameDialog> {
  final user = FirebaseAuth.instance.currentUser!;
  final userNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    userNameController.text = DialogController().getUserName();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      surfaceTintColor: CommonColors.pageBackgroundColor,
      backgroundColor: CommonColors.pageBackgroundColor,
      content: TextFormField(
        controller: userNameController,
      ),
      actions: [
        OutlinedButton(
          style: DialogButton.style,
          // ユーザ名変更の操作を行う.
          onPressed: () {
            bool result = DialogController()
                .updateUserName(userName: userNameController.text);
            Navigator.pop(context);
            DialogController().showUpdatingUserNameResultDialog(
                context: context, result: result);
          },
          child: const Text('ユーザ名を変更する',
              style: CommonTextStyle.dialogButtonTextStyle),
        )
      ],
    );
  }
}
