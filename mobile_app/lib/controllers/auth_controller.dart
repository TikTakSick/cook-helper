import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/auth_service.dart';

// AuthController
class AuthController {
  final AuthService _authService = AuthService();

  // コンストラクタ
  AuthController();

  // メソッドの返り値設定．デフォルトでは，成功とする．
  Map<String, dynamic> response(
      {bool isSuccess = true, String? errrorMessage}) {
    return {
      "isSuccess": isSuccess,
      "errorMessage": errrorMessage,
    };
  }

  // ログイン
  Future<Map> login({email, password}) async {
    try {
      final User? user =
          await _authService.login(email: email, password: password);
      if (user != null) {
        // ログイン成功時の操作
        debugPrint("ログインしました:\n ${user.email} , ${user.uid}");
        return response();
      }
      // ログイン失敗時の操作
      return response(isSuccess: false);
    } on FirebaseAuthException catch (error) {
      return response(
        isSuccess: false,
        errrorMessage: error.message.toString(),
      );
    }
  }

  // サインアップ（ユーザ登録）
  Future<Map> signUp({required email, required password}) async {
    try {
      User? user = await _authService.signUp(email: email, password: password);
      if (user != null) {
        debugPrint("ユーザ登録しました:\n ${user.displayName},${user.uid}");
        // ユーザ登録に成功したので，ホーム画面に遷移する．
        return response();
      }
      return response(isSuccess: false);
    } on FirebaseAuthException catch (error) {
      return response(
          isSuccess: false, errrorMessage: error.message.toString());
    }
  }

  // パスワードリセット
  Future<Map> sendPasswordResetEmail({required email}) async {
    try {
      await _authService.sendPasswordResetEmail(email: email);
      return response();
    } on FirebaseAuthException catch (error) {
      debugPrint(error.message.toString());
      return response(
          isSuccess: false, errrorMessage: error.message.toString());
    }
  }

  // ログアウト
  Future<Map> logOut() async {
    try {
      await _authService.logOut();
      return response();
    } on FirebaseAuthException catch (error) {
      debugPrint("$error");
      return response(
        isSuccess: false,
        errrorMessage: error.message.toString(),
      );
    }
  }

  // ユーザ表示名更新
  Future<Map> updateDisplayName({required String userName}) async {
    try {
      await _authService.updateDisplayName(userName: userName);
      return response();
    } on FirebaseAuthException catch (error) {
      debugPrint("$error");
      return response(
        isSuccess: false,
        errrorMessage: error.message.toString(),
      );
    }
  }

  // ユーザ削除
  Future<Map> delete() async {
    try {
      await _authService.delete();
      return response();
    } on FirebaseAuthException catch (error) {
      debugPrint("$error");
      return response(
        isSuccess: false,
        errrorMessage: error.message.toString(),
      );
    }
  }
}
