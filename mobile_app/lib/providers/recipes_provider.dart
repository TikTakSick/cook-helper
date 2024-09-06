import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/recipe_service.dart';

final recipeProvider = StreamProvider.family((ref, String? uid) {
  return RecipeService(uid: uid).streamRecipesFromFirestore();
});
