import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// services
import '../services/recipe_service.dart';

// RecipeController
class RecipeController {
  final String uid;
  final bool success = true;

  // コンストラクタ
  RecipeController({required this.uid});

  // レシピ追加
  bool addToFirestore({
    required String dishName,
    required String recipeType,
    required String ingredients,
    required String instructions,
    required String url,
  }) {
    // データベース追加
    try {
      RecipeService().addToFirestore(
        uid: uid,
        dishName: dishName,
        recipeType: recipeType,
        ingredients: ingredients,
        instructions: instructions,
        url: url,
      );
      return success;
    } catch (error) {
      debugPrint("Error adding recipe document: $error");
      return !success;
    }
  }

  // レシピ内容編集
  bool updateRecipeToFirestore({
    required String recipeId,
    required String dishName,
    required String recipeType,
    required String ingredients,
    required String instructions,
    required String url,
  }) {
    // データベース内容更新．
    try {
      RecipeService().updateToFirestore(
        uid: uid,
        recipeId: recipeId,
        dishName: dishName,
        recipeType: recipeType,
        ingredients: ingredients,
        instructions: instructions,
        url: url,
      );
      return success;
    } catch (error) {
      debugPrint("Error updating recipe document: $error");
      return !success;
    }
  }

  // レシピ読み出し
}

// レシピの削除に関しては，recipesをサブコレクションとして使用しているため，
// 退会時の処理には向かないのかなぁ
