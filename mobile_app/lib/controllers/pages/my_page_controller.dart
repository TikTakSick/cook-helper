import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// pages
import '../../views/pages/recipe_detail_page.dart';

// models
import '../../models/recipe_model.dart';

class MyPageController {
  //
  _getRecipeRandomlyFromRecipeList({required List<Recipe> recipeList}) {
    final int randomIndex = Random().nextInt(recipeList.length);
    return recipeList[randomIndex];
  }

  // レシピが押された時の動作
  navigatorToRecipeDetailPage({
    required context,
    required recipe,
    required user,
  }) async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      // return WebViewContainer(url: "https://flutter.dev");
      return RecipeDetailPage(recipe: recipe, user: user);
    }));
  }

  // ランダムにレシピを選び，レシピ詳細ページに移る．
  navigatorToRecipeDetailPageRandomly({
    required context,
    required AsyncValue<dynamic> recipes,
    required user,
  }) {
    final List<Recipe> recipeList = recipes.value ?? [];
    if (recipeList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('レシピが登録されていません'),
        ),
      );
      return;
    }
    final Recipe recipe = _getRecipeRandomlyFromRecipeList(
      recipeList: recipeList,
    );
    navigatorToRecipeDetailPage(
      context: context,
      recipe: recipe,
      user: user,
    );
  }
}
