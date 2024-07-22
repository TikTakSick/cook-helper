import 'package:cloud_firestore/cloud_firestore.dart';
import 'recipe_model.dart';

// 特定のユーザのRecipeのみを取得する．
class Recipes {
  String uid; // Firebaseでのユーザのid．Firestoreにも保存される．
  Map<String, Recipe> idToRecipe;

  Recipes({
    required this.uid,
    required this.idToRecipe,
  });
}
