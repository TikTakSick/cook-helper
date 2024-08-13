import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/recipe_model.dart';
import '../services/recipe_service.dart';

AutoDisposeStreamProvider<List<Recipe>> recipesProvider({required String uid}) {
  return StreamProvider.autoDispose<List<Recipe>>(
      (ref) => RecipeService(uid: uid).streamRecipesFromFirestore());
}
