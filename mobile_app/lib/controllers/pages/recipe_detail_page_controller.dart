import 'package:flutter/material.dart';

// pages
import "../../views/pages/recipe_site_page.dart";

// models
import '../../models/recipe_model.dart';

class RecipeDetailPageController {
  final Recipe recipe;
  RecipeDetailPageController({required this.recipe});

  // レシピのwebページを表示させる関数
  navigatorToRecipeSitePage({required context, required recipeUrl}) async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return RecipeWebSitePage(
        recipeDishName: recipe.dishName ?? "",
        recipeUrl: recipe.url ?? "",
      );
    }));
  }

  // レシピ編集ページに遷移する関数
}
