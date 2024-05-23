import 'package:flutter/material.dart';
import '../../views/dialogs/recipe_add_result_dialog.dart';

class RecipeAddPageController {
  // レシピ追加された時の．
  recipeAddToFirestore() {}

  showRecipeAddResultDialog({required context, required bool recipeAddResult}) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return RecipeAddResultDialog(recipeAddResult: recipeAddResult);
        });
  }
}
