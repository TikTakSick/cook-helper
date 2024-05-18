import 'package:cook_helper_mobile_app/view/ui_settings/ui_colors.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gap/gap.dart';

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
      titleTextStyle: CommonTextStyle.dialogTitleTextStyle,
      contentTextStyle: CommonTextStyle.dialogContentTextStyle,
      title: const Text("ユーザ名の変更"),
      content: Container(
          height: 100,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Gap(10),
            Text("・今のユーザ名： ${user.displayName}"),
            const Gap(10),
            TextFormField(controller: userNameController)
          ])),
      actions: [
        OutlinedButton(
          style: DialogButton.style,
          // ユーザ名変更の操作を行う.
          onPressed: () {
            bool result = DialogController()
                .updateUserName(userName: userNameController.text);
            Navigator.pop(context);
            // ユーザ名変更捜査の結果を表示する．
            DialogController().showUpdatingUserNameResultDialog(
                context: context, result: result);
          },
          child: const Text('ユーザ名を変更する',
              style: CommonTextStyle.dialogContentTextStyle),
        )
      ],
    );
  }
}
