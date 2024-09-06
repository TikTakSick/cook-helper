import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

class AuthService {
  // プロパティ値
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // コンストラクタ
  AuthService();

  // ユーザ取得
  User? get currentUser {
    return _auth.currentUser;
  }

  // ユーザの認証状態取得
  Stream<User?> get authStateChanges {
    return _auth.authStateChanges();
  }

  // サインアップ
  Future<User?> signUp({
    required String email,
    required String password,
  }) async {
    final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    return userCredential.user;
  }

  // ログイン
  Future<User?> login({required email, required password}) async {
    final userCredential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    return userCredential.user;
  }

  // ログアウト
  Future<void> logOut() async {
    await _auth.signOut();
  }

  // パスワードリセット
  Future<void> sendPasswordResetEmail({required email}) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // ユーザ表示名変更
  Future<void> updateDisplayName({required String userName}) async {
    await currentUser?.updateDisplayName(userName);
  }

  // ユーザ削除
  Future<void> delete() async {
    await currentUser?.delete();
  }
}
