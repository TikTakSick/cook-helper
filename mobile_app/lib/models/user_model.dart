import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  // プロパティ値
  final FirebaseAuth auth;
  final User? user;
  String? userName;
  String? uid;

  // コンストラクタ
  UserModel({required this.auth, required this.user}) {
    userName = (user?.displayName == null || user?.displayName == "")
        ? "<名無し>"
        : user!.displayName.toString();
    uid = user!.uid;
  }

  // 以下メソッド

  // ユーザ名更新
  Future<void> updateUserName({required String userName}) async {
    print("HERE11");
    try {
      await user!.updateDisplayName(userName);
    } on FirebaseAuthException catch (error) {
      print("$error");
    }
  }

  // パスワードリセット
  // Future<void> resetPassword(){

  // }

  // ユーザ削除
  Future<void> delete() async {
    print("HERE12");
    try {
      await user!.delete();
      await auth.signOut();
    } on FirebaseAuthException catch (error) {
      print("${error}");
    }
  }

  // ログアウト
  Future<void> logOut() async {
    print("HERE13");
    try {
      await auth.signOut();
    } on FirebaseAuthException catch (error) {
      print("${error}");
    }
  }
}
