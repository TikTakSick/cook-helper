import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// models
import '../models/recipe_model.dart';

// RecipeController
class RecipeController {
  final String? uid;
  final bool success = true;
  final CollectionReference recipesCollectionRef;

  // initializer list (constructor)
  RecipeController.setDbRef(String this.uid)
      : recipesCollectionRef = FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('recipes');

  // レシピ追加
  bool addRecipeToFirestore({
    required String dishName,
    required String recipeType,
    required String ingredients,
    required String instructions,
    required String url,
  }) {
    // レシピインスタンス生成
    Recipe recipe = Recipe(
      dishName: dishName,
      recipeType: recipeType,
      ingredients: ingredients,
      instructions: instructions,
      url: url,
    );
    // データベース追加
    try {
      recipe.addToFirestore(recipesCollectionRef: recipesCollectionRef);
      return success;
    } catch (error) {
      print("Error adding recipe document: $error");
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
    // レシピインスタンス生成
    Recipe recipe = Recipe(
      recipeId: recipeId,
      dishName: dishName,
      recipeType: recipeType,
      ingredients: ingredients,
      instructions: instructions,
      url: url,
    );

    // データベース内容更新．
    try {
      recipe.updateToFirestore(recipesCollectionRef: recipesCollectionRef);
      return success;
    } catch (error) {
      print("Error updating recipe document: $error");
      return !success;
    }
  }
}

// レシピの削除に関しては，recipesをサブコレクションとして使用しているため，
// 退会時の処理には向かないのかなぁぁあ
