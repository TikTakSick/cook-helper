import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// models
import '../models/user_model.dart';

// views
import '../views/pages/login_page.dart';
import '../views/pages/my_page.dart';

// ユーザの認証状態を提供するProvider
final autoStateChangesProvider = StreamProvider.autoDispose<User?>((ref) {
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  return firebaseAuth.authStateChanges();
});

// firebaseAuthProvider
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

// AuthControllerProvider
final authControllerProvider =
    StateNotifierProvider<AuthController, UserModel?>((ref) {
  return AuthController(
      initialUser: ref.watch(firebaseAuthProvider).currentUser);
});

// AuthController
class AuthController extends StateNotifier<UserModel?> {
  final bool success = true;
  final _auth = FirebaseAuth.instance;

  // コンストラクタ
  AuthController({User? initialUser})
      : super(UserModel(auth: FirebaseAuth.instance, user: initialUser)) {
    // userの変更を検知して状態を更新
    _auth.userChanges().listen((user) {
      state = UserModel(auth: _auth, user: user);
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
    return state!.userName;
  }

  // ユーザID取得
  String? readUserID() {
    return state!.uid;
  }

  // ログイン
  Future<String?> signInWithEmailAndPassword({context, email, password}) async {
    try {
      final User? user = await state!
          .signInWithEmailAndPassword(email: email, password: password);
      if (user != null) {
        debugPrint("ログインしました:\n ${user.email} , ${user.uid}");
        // ログイン成功したので，ホーム画面に遷移．
        await Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) {
            return const MyPage();
          }),
        );
        return null;
      }
      return null;
    } on FirebaseAuthException catch (error) {
      return error.message.toString();
    }
  }

  // ユーザ登録
  Future<String?> createUserWithEmailAndPassword(
      {context, email, password}) async {
    try {
      final User? user = await state!
          .createUserWithEmailAndPassword(email: email, password: password);
      if (user != null) {
        debugPrint("ユーザ登録しました:\n ${user.email} , ${user.uid}");
        // ユーザ登録に成功したので，ホーム画面に遷移する．
        await Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) {
            return const MyPage();
          }),
        );
        return null;
      }
      return null;
    } on FirebaseAuthException catch (error) {
      return error.message.toString();
    }
  }

  // パスワードリセット
  Future<String?> sendPasswordResetEmail({email}) async {
    try {
      await state!.sendPasswordResetEmail(email: email);
      return null;
    } on FirebaseAuthException catch (error) {
      debugPrint(error.message.toString());
      return error.message.toString();
    }
  }

  // ユーザ名更新
  Future<bool> updateUserName({required String userName}) async {
    try {
      await state!.updateUserName(userName: userName);
      return success;
    } on FirebaseAuthException catch (error) {
      debugPrint("$error");
      return !success;
    }
  }

  // ログアウト
  Future<bool> logOut({required context}) async {
    try {
      await state!.logOut();
      _navigateToLoginPage(context: context);
      return success;
    } catch (e) {
      // debugPrint("${e}");
      return !success;
    }
  }

  // ユーザ削除
  Future<bool> delete({required context}) async {
    try {
      await state!.delete();
      _navigateToLoginPage(context: context);
      return success;
    } catch (e) {
      debugPrint("${e}");
      return !success;
    }
  }
}
