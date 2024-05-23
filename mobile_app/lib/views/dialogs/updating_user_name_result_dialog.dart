import '../utils/result_dialog.dart';

class UpdatingUserNameResultDialog extends ResultDialog {
  final bool updatingUserNameResult;
  const UpdatingUserNameResultDialog({
    super.key,
    required this.updatingUserNameResult,
  }) : super(topic: "ユーザ名変更", result: updatingUserNameResult);
}
