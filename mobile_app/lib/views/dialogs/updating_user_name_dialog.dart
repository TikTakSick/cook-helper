import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gap/gap.dart';

// views_utils
import '../utils/text_styles.dart';
import '../utils/button_styles.dart';
import '../utils/colors.dart';
// controllers
import '../../controllers/auth_controller.dart';
import '../../controllers/dialogs/setting_dialog_controller.dart';

// providers
import '../../providers/auth_provider.dart';

class UpdatingUserNameDialog extends ConsumerStatefulWidget {
  const UpdatingUserNameDialog({Key? key}) : super(key: key);

  @override
  UpdatingUserNameDialogState createState() => UpdatingUserNameDialogState();
}

class UpdatingUserNameDialogState
    extends ConsumerState<UpdatingUserNameDialog> {
  // ボタンが押されたかどうかのフラグ
  bool buttonPressed = false;

  // AuthControllerのインスタンス
  final authController = AuthController();

  // ユーザ名変更用のコントローラ
  final userNameController = TextEditingController();

  late String? currentUserName;
  @override
  Widget build(BuildContext context) {
    final User? user = ref.watch(authUserProvider);
    currentUserName = user?.displayName ?? "";
    return AlertDialog(
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
          OutlinedButton(
              style: DialogButton.style,
              onPressed: () async {
                setState(() {
                  buttonPressed = true;
                });

                // ユーザ名変更の操作を行う.
                final response = await authController.updateDisplayName(
                    userName: userNameController.text);
                if (!context.mounted) {
                  return;
                }
                // ユーザ名変更捜査の結果を表示する．
                Navigator.pop(context);
                SettingDialogController().showUpdatingUserNameResultDialog(
                    context: context, result: response["isSuccess"]);
              },
              child: buttonPressed
                  ? const CircularProgressIndicator(
                      strokeWidth: 2.0, color: CommonColors.textColor)
                  : const Text('ユーザ名を変更する', style: dialogButtonTextStyle))
        ]);
  }
}
