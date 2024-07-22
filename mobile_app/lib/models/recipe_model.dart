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
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    // Json型データを取得
    final recipeDocument = snapshot.data();
    return Recipe(
      recipeId: recipeDocument?['recipeId'],
      dishName: recipeDocument?['dishName'],
      recipeType: recipeDocument?['recipeType'],
      ingredients: recipeDocument?['ingredients'],
      instructions: recipeDocument?['instructions'],
      url: recipeDocument?['url'],
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

  // レシピ追加
  Future<void> addToFirestore({
    required CollectionReference recipesCollectionRef,
  }) async {
    await recipesCollectionRef.add(toFirestore()).then((documentSnapshot) =>
        {print("Added Data with ID: ${documentSnapshot.id}")});
  }

  // レシピ内容編集
  Future<void> updateToFirestore({
    required CollectionReference recipesCollectionRef,
  }) async {
    await recipesCollectionRef
        .doc(recipeId)
        .update(toFirestore())
        .then((value) => print("DocumentSnapshot successfully updated!"));
  }
}
