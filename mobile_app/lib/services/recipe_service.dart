import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/recipe_model.dart';

class RecipeService {
  // レシピ追加
  Future<void> addToFirestore({
    required String uid,
    required String dishName,
    required String recipeType,
    required String ingredients,
    required String instructions,
    required String url,
  }) async {
    // 参照先作成
    CollectionReference recipesCollectionRef = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('recipes');

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
            {print("Added Data with ID: ${documentSnapshot.id}")});
  }

  // レシピ内容編集
  Future<void> updateToFirestore({
    required String uid,
    required String recipeId,
    required String dishName,
    required String recipeType,
    required String ingredients,
    required String instructions,
    required String url,
  }) async {
    // レシピインスタンス作成．
    Recipe recipe = Recipe(
      dishName: dishName,
      recipeType: recipeType,
      ingredients: ingredients,
      instructions: instructions,
      url: url,
    );
    // 参照先作成
    DocumentReference recipeDocumentRef = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('recipes')
        .doc(recipeId);
    // 内容変更
    await recipeDocumentRef
        .update(recipe.toFirestore())
        .then((value) => print("DocumentSnapshot successfully updated!"));
  }

  // レシピ読みだし
  Future<List<Recipe>> readAllRecipesFromFirestore({
    required String uid,
  }) async {
    // リスト作成
    List<Recipe> recipe_list = [];

    // 参照先作成
    CollectionReference recipesCollectionRef = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('recipes');

    // レシピ取得．
    await recipesCollectionRef.get().then((querySnapshot) {
      for (var recipeDocumnetSnapshot in querySnapshot.docs) {
        // Firestoreからレシピを取得する．
        final Recipe recipe = Recipe.fromFirestore(recipeDocumnetSnapshot
            as QueryDocumentSnapshot<Map<String, dynamic>>);
        // レシピを追加
        recipe_list.add(recipe);
        debugPrint(
            '${recipeDocumnetSnapshot.id} => ${recipeDocumnetSnapshot.data()}');
      }
    });
    return recipe_list;
  }
}
