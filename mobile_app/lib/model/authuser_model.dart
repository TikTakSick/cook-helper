import 'package:firebase_auth/firebase_auth.dart';

class AuthUserModel {
  User user = FirebaseAuth.instance.currentUser!;

  getUserName() {
    return user.displayName;
  }

  updateUserName({required String userName}) async {
    await user.updateDisplayName(userName);
  }
}
