import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

// pages
import "../../views/pages/recipe_site_page.dart";
import "../../views/pages/recipe_edit_page.dart";

// models
import '../../models/recipe_model.dart';

class RecipeDetailPageController {
  final Recipe recipe;
  final User user;
  RecipeDetailPageController({required this.recipe, required this.user});

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
        user: user,
      );
    }));
  }
}
