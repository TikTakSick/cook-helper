import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

// ui_settings
import '../ui_settings/ui_textstyles.dart';
import '../ui_settings/ui_buttonstyles.dart';
import '../ui_settings/ui_colors.dart';
// controllers
import '../../controllers/user_controller.dart';
import '../../controllers/dialogs/setting_dialog_controller.dart';

// ユーザ名変更のダイアログを実装している．
//　以下二つの部分に分かれている．
// UpdatingUserNameDialog：ダイアログ本体
// UpdatingUserNameDialogButton：ダイアログボタン部分

// ダイアログボタン本体
class UpdatingUserNameDialog extends ConsumerWidget {
  UpdatingUserNameDialog({super.key});
  final userNameController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // UserProviderを呼び出す．
    final UserController userController = ref.read(userProvider.notifier);
    // ユーザ名を取得し，テキストフィールドに入力する．
    String currentUserName = userController.readUserName();
    userNameController.text = currentUserName;

    return AlertDialog(
      surfaceTintColor: CommonColors.dialogBackgroundColor,
      backgroundColor: CommonColors.dialogBackgroundColor,
      titleTextStyle: dialogTitleTextStyle,
      contentTextStyle: dialogContentTextStyle,
      title: const Text("ユーザ名の変更"),
      content: SizedBox(
          height: 100,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Gap(10),
            Text("現在のユーザ名:  $currentUserName"),
            const Gap(10),
            TextFormField(controller: userNameController)
          ])),
      // ボタン部分
      actions: [
        UpdatingUserNameDialogButton(
            newUserName: userNameController.text,
            userController: userController),
      ],
    );
  }
}

// ダイアログボタン部分
class UpdatingUserNameDialogButton extends StatefulWidget {
  final String newUserName;
  final UserController userController;
  const UpdatingUserNameDialogButton(
      {super.key, required this.newUserName, required this.userController});

  @override
  UpdatingUserNameDialogButtonState createState() =>
      UpdatingUserNameDialogButtonState();
}

class UpdatingUserNameDialogButtonState
    extends State<UpdatingUserNameDialogButton> {
  bool buttonPressed = false;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        style: DialogButton.style,
        onPressed: () async {
          setState(() {
            buttonPressed = true;
          });

          // ユーザ名変更の操作を行う.
          bool result = await widget.userController
              .updateUserName(userName: widget.newUserName);
          if (!context.mounted) {
            return;
          }
          // ユーザ名変更捜査の結果を表示する．
          Navigator.pop(context);
          SettingDialogController().showUpdatingUserNameResultDialog(
              context: context, result: result);
        },
        child: buttonPressed
            ? const CircularProgressIndicator(
                strokeWidth: 2.0, color: CommonColors.textColor)
            : const Text('ユーザ名を変更する', style: dialogButtonTextStyle));
  }
}
