import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  // プロパティ値
  final FirebaseAuth auth;
  final User? user;
  String? userName;
  String? uid;

  // コンストラクタ
  UserModel({required this.auth, required this.user}) {
    if (user != null) {
      userName = (user?.displayName == null || user?.displayName == "")
          ? "<名無し>"
          : user!.displayName.toString();
      uid = user!.uid;
    } else {
      uid = null;
      userName = null;
    }
  }

  // 以下メソッド

  // サインアップ
  Future<void> signUp({email, password}) async {
    await auth.signInWithEmailAndPassword(email: email, password: password);
  }

  // ログイン
  Future<User?> signInWithEmailAndPassword({email, password}) async {
    final userCredential =
        await auth.signInWithEmailAndPassword(email: email, password: password);
    return userCredential.user;
  }

  // サインアップ
  Future<User?> createUserWithEmailAndPassword({email, password}) async {
    final userCredential = await auth.createUserWithEmailAndPassword(
        email: email, password: password);
    return userCredential.user;
  }

  // パスワードリセット
  Future<void> sendPasswordResetEmail({email}) async {
    await auth.sendPasswordResetEmail(email: email);
  }

  // ユーザ名更新
  Future<void> updateUserName({required String userName}) async {
    await user!.updateDisplayName(userName);
  }

  // ユーザ削除
  Future<void> delete() async {
    await user!.delete();
    await auth.signOut();
  }

  // ログアウト
  Future<void> logOut() async {
    await auth.signOut();
  }
}
