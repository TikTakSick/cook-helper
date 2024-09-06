import 'package:flutter/material.dart';

// pages
import "../../views/pages/recipe_site_page.dart";
import "../../views/pages/recipe_edit_page.dart";

// models
import '../../models/recipe_model.dart';

class RecipeDetailPageController {
  final Recipe recipe;
  final String uid;
  RecipeDetailPageController({required this.recipe, required this.uid});

  // レシピのwebページを表示させる関数
  navigatorToRecipeSitePage({required context}) async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return RecipeWebSitePage(
        recipeDishName: recipe.dishName ?? "",
        recipeUrl: recipe.url ?? "",
      );
    }));
  }

  // レシピ編集ページに遷移する関数
  navigatorToRecipeEditPage({required context}) async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return RecipeEditPage(
        recipe: recipe,
        uid: uid,
      );
    }));
  }
}
