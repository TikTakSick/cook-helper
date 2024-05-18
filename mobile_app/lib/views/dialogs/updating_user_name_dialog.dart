import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

// ui_settings
import '../ui_settings/ui_textstyles.dart';
import '../ui_settings/ui_buttonstyles.dart';
import '../ui_settings/ui_colors.dart';
// controllers
import '../../controllers/user_controller.dart';
import '../../controllers/dialogs/dialogs_controller.dart';

class UpdatingUserNameDialog extends ConsumerWidget {
  UpdatingUserNameDialog({super.key});
  final userNameController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final User user = ref.watch(userProvider);
    String userName = ref.read(userProvider.notifier).readUserName();
    userNameController.text = userName;

    return AlertDialog(
      surfaceTintColor: CommonColors.dialogBackgroundColor,
      backgroundColor: CommonColors.dialogBackgroundColor,
      titleTextStyle: CommonTextStyle.dialogTitleTextStyle,
      contentTextStyle: CommonTextStyle.dialogContentTextStyle,
      title: const Text("ユーザ名の変更"),
      content: SizedBox(
          height: 100,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Gap(10),
            Text("現在のユーザ名:  $userName"),
            const Gap(10),
            TextFormField(controller: userNameController)
          ])),
      actions: [
        OutlinedButton(
            style: DialogButton.style,
            onPressed: () async {
              // ユーザ名変更の操作を行う.
              bool result = await ref
                  .read(userProvider.notifier)
                  .updateUserName(userName: userNameController.text);
              if (!context.mounted) {
                return;
              }
              // ユーザ名変更捜査の結果を表示する．
              Navigator.pop(context);
              DialogController().showUpdatingUserNameResultDialog(
                  context: context, result: result);
              // Provider状態変更を行う．
            },
            child: const Text('ユーザ名を変更する',
                style: CommonTextStyle.dialogButtonTextStyle))
      ],
    );
  }
}
