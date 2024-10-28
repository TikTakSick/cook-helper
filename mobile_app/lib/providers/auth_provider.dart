import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// ユーザ情報の変更を提供するProvider
final authUserChangesProvider = StreamProvider.autoDispose<User?>((ref) {
  final firebaseAuthInstance = FirebaseAuth.instance;
  return firebaseAuthInstance.userChanges();
});

// ユーザを提供するProvider
final authUserProvider = Provider.autoDispose<User?>((ref) {
  final authState = ref.watch(authUserChangesProvider);
  debugPrint(
      "Your Name: ${authState.value?.displayName ?? ""} Your Id ${authState.value?.uid ?? ""}");
  return authState.asData?.value;
});
