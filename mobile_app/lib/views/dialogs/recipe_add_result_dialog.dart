import '../utils/result_dialog.dart';

class RecipeAddResultDialog extends ResultDialog {
  final bool recipeAddResult;
  const RecipeAddResultDialog({
    super.key,
    required this.recipeAddResult,
  }) : super(topic: "ユーザ名変更", result: recipeAddResult);
}
