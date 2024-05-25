import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// models
import '../models/user_model.dart';

// views
import '../views/pages/login_page.dart';

// ユーザの認証状態を提供するProvider
final autoStateChangesProvider = StreamProvider.autoDispose<User?>((ref) {
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  return firebaseAuth.authStateChanges();
});

// firebaseAuthProvider
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final authControllerProvider =
    StateNotifierProvider<AuthController, User?>((ref) {
  return AuthController(initialUser: FirebaseAuth.instance.currentUser);
});

// AuthController
class AuthController extends StateNotifier<User?> {
  final bool success = true;
  final _auth = FirebaseAuth.instance;
  UserModel? userModel;

  // コンストラクタ
  AuthController({User? initialUser}) : super(initialUser) {
    // userの変更を検知して状態を更新
    _auth.userChanges().listen((user) {
      state = user;
      userModel = UserModel(auth: _auth, user: state);
    });
  }

  // ログインページに戻る
  Future<void> _navigateToLoginPage({required context}) async {
    await Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) {
      return const LoginPage();
    }), (_) {
      return false;
    });
  }

  // ユーザ名取得
  String? readUserName() {
    return userModel!.userName;
  }

  // ユーザID取得
  String? readUserID() {
    return userModel!.uid;
  }

  // ユーザ名更新
  Future<bool> updateUserName({required String userName}) async {
    print("HERE4");
    try {
      await userModel!.updateUserName(userName: userName);
      return success;
    } on FirebaseAuthException catch (error) {
      print("$error");
      return !success;
    }
  }

  // ログアウト
  Future<bool> logOut({required context}) async {
    try {
      await userModel!.logOut();
      _navigateToLoginPage(context: context);
      return success;
    } catch (e) {
      // print("${e}");
      return !success;
    }
  }

  // パスワードリセット
  // Future<void> resetPassword(){

  // }

  // ユーザ削除
  Future<bool> delete({required context}) async {
    try {
      await userModel!.delete();
      _navigateToLoginPage(context: context);
      return success;
    } catch (e) {
      print("${e}");
      return !success;
    }
  }
}
