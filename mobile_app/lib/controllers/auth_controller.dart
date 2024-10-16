import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/auth_service.dart';

// AuthController
class AuthController {
  final AuthService _authService;

  // コンストラクタ
  AuthController() : _authService = AuthService();

  // メソッドの返り値設定．デフォルトでは，成功とする．
  Map<String, dynamic> _authResponse({bool isSuccess = true, String? message}) {
    return {
      "isSuccess": isSuccess,
      "message": message,
    };
  }

  // ログイン
  Future<Map> login({
    required email,
    required password,
  }) async {
    String loginErrorMessage = "";

    // ログイン成功時の処理
    try {
      final User? user =
          await _authService.login(email: email, password: password);
      if (user == null) {
        // ユーザがnullの場合，失敗とする．
        return _authResponse(isSuccess: false);
      } else if (user.emailVerified == false) {
        // verifyEmailModeでメールアドレスが検証されていない場合も失敗とする．
        loginErrorMessage = "メールアドレスが検証されていません";
        debugPrint(loginErrorMessage);
        return _authResponse(isSuccess: false, message: loginErrorMessage);
      }
      debugPrint("ログインしました:\n ${user.email} , ${user.uid}");
      return _authResponse();
      // ログイン失敗時の操作
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        loginErrorMessage = "ユーザが見つかりません";
        debugPrint(loginErrorMessage);
      } else if (e.code == 'wrong-password') {
        loginErrorMessage = "パスワードが違います";
        debugPrint(loginErrorMessage);
      }
      return _authResponse(isSuccess: false, message: loginErrorMessage);
    } catch (e) {
      return _authResponse(isSuccess: false, message: e.toString());
    }
  }

  // サインアップ（ユーザ登録）
  Future<Map> signUp({required email, required password}) async {
    String signUpMessage = "";
    // サインアップ成功時の処理
    try {
      User? user = await _authService.signUp(email: email, password: password);
      // ユーザがnullの場合，失敗とする．
      if (user == null) {
        return _authResponse(isSuccess: false);
      }
      // ユーザ登録成功後，確認メールを送信する．
      debugPrint("ユーザ登録しました:\n ${user.displayName},${user.uid}");
      await _authService.sendEmailVerification(user: user);
      signUpMessage = "メールアドレス確認メールを送信しました";
      return _authResponse(isSuccess: true, message: signUpMessage);
    } on FirebaseAuthException catch (e) {
      if (e.code == "weak-password") {
        signUpMessage = "パスワードが弱いです";
        debugPrint(signUpMessage);
      } else if (e.code == "email-already-in-use") {
        signUpMessage = "このメールアドレスは既に使われています";
        debugPrint(signUpMessage);
      }
      return _authResponse(isSuccess: false, message: signUpMessage);
    } catch (e) {
      return _authResponse(isSuccess: false, message: e.toString());
    }
  }

  Future<Map> sendEmailVerification({required email, required password}) async {
    String message = "";
    // ログイン処理機能を利用してユーザを取得し，メールアドレス確認メールを送信する．
    try {
      // ユーザを取得
      final User? user =
          await _authService.login(email: email, password: password);
      // ユーザがnullの場合，失敗とする．
      if (user == null) {
        return _authResponse(isSuccess: false);
      }
      // メールがすでに検証されている場合
      else if (user.emailVerified == true) {
        message = "対象のメールアドレスは，検証済みです";
        debugPrint(message);
        return _authResponse(isSuccess: true, message: message);
      }
      // メールアドレス確認メールを送信する．
      await _authService.sendEmailVerification(user: user);
      message = "メールアドレス確認メールを送信しました";
      return _authResponse(isSuccess: true, message: message);

      // ログイン失敗時の操作
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        message = "ユーザが見つかりません";
        debugPrint(message);
      } else if (e.code == 'wrong-password') {
        message = "パスワードが違います";
        debugPrint(message);
      }
      return _authResponse(isSuccess: false, message: message);
    } catch (e) {
      return _authResponse(isSuccess: false, message: e.toString());
    }
  }

  // パスワードリセット
  Future<Map> sendPasswordResetEmail({required email}) async {
    try {
      await _authService.sendPasswordResetEmail(email: email);
      return _authResponse(message: "パスワードリセット用のメールを送信しました");
    } on FirebaseAuthException catch (error) {
      debugPrint(error.message.toString());
      return _authResponse(isSuccess: false, message: error.message.toString());
    }
  }

  // ログアウト
  Future<Map> logOut() async {
    try {
      await _authService.logOut();
      return _authResponse();
    } on FirebaseAuthException catch (error) {
      debugPrint("$error");
      return _authResponse(
        isSuccess: false,
        message: error.message.toString(),
      );
    }
  }

  // ユーザ表示名更新
  Future<Map> updateDisplayName({required String userName}) async {
    try {
      await _authService.updateDisplayName(userName: userName);
      return _authResponse();
    } on FirebaseAuthException catch (error) {
      debugPrint("$error");
      return _authResponse(
        isSuccess: false,
        message: error.message.toString(),
      );
    }
  }

  // ユーザ削除
  Future<Map> delete() async {
    try {
      await _authService.delete();
      return _authResponse();
    } on FirebaseAuthException catch (error) {
      debugPrint("$error");
      return _authResponse(
        isSuccess: false,
        message: error.message.toString(),
      );
    }
  }
}
