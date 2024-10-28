import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  // プロパティ値
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late final User? _currentUser;

  // コンストラクタ
  AuthService() {
    _currentUser = _auth.currentUser;
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

  // メールアドレス確認
  Future<void> sendEmailVerification({required User user}) async {
    await user.sendEmailVerification();
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
    await _currentUser?.updateDisplayName(userName);
  }

  // ユーザ削除
  Future<void> delete() async {
    await _currentUser?.delete();
  }
}
