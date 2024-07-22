import 'result_dialog.dart';

class AddRecipeToFirestoreResultDialog extends ResultDialog {
  final bool addRecipeToFirestoreResult;
  const AddRecipeToFirestoreResultDialog({
    super.key,
    required this.addRecipeToFirestoreResult,
  }) : super(topic: "レシピ追加", result: addRecipeToFirestoreResult);
}
