import 'package:flutter/material.dart';
import '../../views/dialogs/recipe_add_result_dialog.dart';

class RecipeAddPageController {
  // レシピをFirestoreに追加
  registerRecipeoFirestore() {}

  // ダイアログ表示
  showRecipeAddResultDialog({required context, required bool recipeAddResult}) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return RecipeAddResultDialog(recipeAddResult: recipeAddResult);
        });
  }
}
