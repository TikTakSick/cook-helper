import 'package:cloud_firestore/cloud_firestore.dart';

class Recipe {
  final String? recipeId; // Firestore側で自動的に作成されるID
  final String? dishName;
  final String? recipeType;
  final String? ingredients;
  final String? instructions;
  final String? url;

  // コンストラクタ
  Recipe({
    this.recipeId,
    this.dishName,
    this.recipeType,
    this.ingredients,
    this.instructions,
    this.url,
  });

  // Firestoreからデータを取得する際に利用する．
  factory Recipe.fromFirestore(
    QueryDocumentSnapshot<Map<String, dynamic>> recipeDocumentSnapshot,
  ) {
    // Json型データを取得
    final recipeDocument = recipeDocumentSnapshot.data();
    return Recipe(
      recipeId: recipeDocument['recipeId'],
      dishName: recipeDocument['dishName'],
      recipeType: recipeDocument['recipeType'],
      ingredients: recipeDocument['ingredients'],
      instructions: recipeDocument['instructions'],
      url: recipeDocument['url'],
    );
  }

  // Firestoreに追加時に利用．
  Map<String, dynamic> toFirestore() {
    return {
      if (dishName != null) 'dishName': dishName,
      if (recipeType != null) 'recipeType': recipeType,
      if (ingredients != null) 'ingredients': ingredients,
      if (instructions != null) 'instructions': instructions,
      if (url != null) 'url': url,
    };
  }
}
