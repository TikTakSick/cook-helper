import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/recipe_model.dart';

class RecipeService {
  final String? uid;
  final CollectionReference recipesCollectionRef;

  // コンストラクタ
  RecipeService({required this.uid})
      : recipesCollectionRef = FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('recipes');

  // レシピ追加
  Future<void> addToFirestore({
    required String dishName,
    required String recipeType,
    required String ingredients,
    required String instructions,
    required String url,
  }) async {
    // レシピインスタンス生成
    Recipe recipe = Recipe(
      dishName: dishName,
      recipeType: recipeType,
      ingredients: ingredients,
      instructions: instructions,
      url: url,
    );

    // データベース追加
    await recipesCollectionRef.add(recipe.toFirestore()).then(
        (documentSnapshot) =>
            {debugPrint("Added Data with ID: ${documentSnapshot.id}")});
  }

  // レシピ内容編集
  Future<void> updateToFirestore({
    required String recipeId,
    required String dishName,
    required String recipeType,
    required String ingredients,
    required String instructions,
    required String url,
  }) async {
    Recipe recipe = Recipe(
      recipeId: recipeId,
      dishName: dishName,
      recipeType: recipeType,
      ingredients: ingredients,
      instructions: instructions,
      url: url,
    );
    // 参照先作成
    DocumentReference recipeDocumentRef = recipesCollectionRef.doc(recipeId);
    // 内容変更
    await recipeDocumentRef
        .update(recipe.toFirestore())
        .then((value) => debugPrint("DocumentSnapshot successfully updated!"));
  }

  // レシピ読みだし
  Stream streamRecipesFromFirestore() {
    return recipesCollectionRef.orderBy('dishName').snapshots().map((snapshot) {
      final recipes = snapshot.docs
          .map((recipeDocument) => Recipe.fromFirestore(
              recipeDocument as QueryDocumentSnapshot<Map<String, dynamic>>))
          .toList();
      //デバッグ出力

      // for (var recipe in recipes) {
      //   debugPrint("Recipe: ${recipe.dishName}, ${recipe.recipeId}");
      // }
      return recipes;
    });
  }

  // レシピ削除
  Future deleteFromFirestore({
    required String recipeId,
  }) async {
    // 参照先作成
    DocumentReference recipeDocumentRef = recipesCollectionRef.doc(recipeId);
    // 削除
    await recipeDocumentRef.delete().then((value) {
      debugPrint("RecipeDocument  successfully deleted!");
    });
  }
}
