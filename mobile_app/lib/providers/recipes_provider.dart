import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/recipe_service.dart';
import './auth_provider.dart';

final recipesProvider = StreamProvider.family.autoDispose((ref, String? uid) {
  final authUser = ref.watch(authUserProvider);
  final RecipeService recipeService = RecipeService(uid: authUser?.uid);
  return recipeService.streamRecipesFromFirestore();
});
