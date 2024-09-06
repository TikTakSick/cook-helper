import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';

final authProvider = StreamProvider.family((ref, String? uid) {
  authService = AuthService(uid: uid);
  return authservice.streamRecipesFromFirestore();
});
