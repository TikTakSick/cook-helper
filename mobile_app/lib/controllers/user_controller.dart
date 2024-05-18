import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProvider = StateNotifierProvider<UserController, User?>(
  (ref) => UserController(initialUser: FirebaseAuth.instance.currentUser),
);

class UserController extends StateNotifier<User?> {
  final _auth = FirebaseAuth.instance;
  final bool success = true;
  // コンストラクタ
  UserController({User? initialUser}) : super(initialUser) {
    // Userの変更を検知して状態を更新
    _auth.userChanges().listen((user) {
      state = user;
    });
  }

  // ユーザ名取得
  String readUserName() {
    if (state?.displayName == null) {
      return "";
    } else {
      return state!.displayName.toString();
    }
  }

  // ユーザ名更新
  Future<bool> updateUserName({required String userName}) async {
    try {
      await state?.updateDisplayName(userName);
      return success;
    } on FirebaseAuthException catch (error) {
      print("$error");
      return !success;
    }
  }

  // ログアウト
  Future<bool> logOut({required context}) async {
    try {
      _auth.signOut();
      return success;
    } on FirebaseAuthException catch (error) {
      print("$error");
      return !success;
    }
  }
}
