import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

// views_utils
import '../utils/text_styles.dart';
import '../utils/button_styles.dart';
import '../utils/colors.dart';
// controllers
import '../../controllers/auth_controller.dart';
import '../../controllers/dialogs/setting_dialog_controller.dart';

// ユーザ名変更のダイアログを実装している．
// 以下二つの部分に分かれている．
// - UpdatingUserNameDialog：ダイアログ本体
// - UpdatingUserNameDialogButton：ダイアログボタン部分

// ダイアログボタン本体
class UpdatingUserNameDialog extends ConsumerWidget {
  const UpdatingUserNameDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // UserProviderを呼び出す．
    final AuthController? authController =
        ref.watch(authControllerProvider.notifier);
    // ユーザ名を取得し，テキストフィールドに入力する．
    String? currentUserName = authController!.readUserName();

    return UpdatingUserNameDialogButton(
        authController: authController, currentUserName: currentUserName!);
  }
}

// ダイアログボタン部分
class UpdatingUserNameDialogButton extends StatefulWidget {
  final authController;
  final String currentUserName;
  const UpdatingUserNameDialogButton(
      {super.key, required this.authController, required this.currentUserName});

  @override
  UpdatingUserNameDialogButtonState createState() =>
      UpdatingUserNameDialogButtonState();
}

class UpdatingUserNameDialogButtonState
    extends State<UpdatingUserNameDialogButton> {
  bool buttonPressed = false;
  final userNameController = TextEditingController();

  @override
  initState() {
    super.initState();
    userNameController.text = widget.currentUserName;
  }

  @override
  Widget build(BuildContext context) {
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
              Text("現在のユーザ名:  ${widget.currentUserName}"),
              const Gap(10),
              TextFormField(controller: userNameController)
            ])),
        // ボタン部分
        actions: [
          OutlinedButton(
              style: DialogButton.style,
              onPressed: () async {
                setState(() {
                  buttonPressed = true;
                });

                // ユーザ名変更の操作を行う.
                bool result = await widget.authController
                    .updateUserName(userName: userNameController.text);
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
                  : const Text('ユーザ名を変更する', style: dialogButtonTextStyle))
        ]);
  }
}
