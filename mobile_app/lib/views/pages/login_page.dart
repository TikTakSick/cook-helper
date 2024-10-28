import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

// controllers
import "../../controllers/auth_controller.dart";

// utils
import '../utils/page_title.dart';
import '../utils/colors.dart';
import "../utils/button_styles.dart";
import "../utils/text_styles.dart";

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  String _email = '';
  String _password = '';
  String infoMessage = '';
  bool hasError = false;

  final String titleName = "ログインページ";

  void _showMessage(String message) {
    setState(() {
      infoMessage = message;
    });
    final String snackBarMessage =
        hasError ? "エラーが発生しました:\n $infoMessage" : infoMessage;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(snackBarMessage)));
  }

  void _setHasError({boolean = true}) {
    setState(() {
      hasError = boolean;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authController = AuthController();

    return Scaffold(
      backgroundColor: CommonColors.pageBackgroundColor,
      appBar: AppBar(
        title: PageTitle(pageTitleName: titleName),
        backgroundColor: CommonColors.primaryColor,
      ),
      body: Center(
        child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Gap(30),
                  // メールアドレス入力欄
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'メールアドレス'),
                    onChanged: (String value) {
                      setState(() {
                        _email = value;
                      });
                    },
                  ),
                  // パスワード入力欄
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'パスワード'),
                    obscureText: true,
                    onChanged: (String value) {
                      setState(() {
                        _password = value;
                      });
                    },
                  ),
                  const Gap(50),
                  // ユーザ登録（サインアップ）ボタン
                  ElevatedButton(
                    style: AuthButton.style,
                    child: const Text('ユーザ登録（サインアップ）',
                        style: elevatedButtonTextStyle),
                    onPressed: () async {
                      // サインアップ・ユーザ登録
                      final response = await authController.signUp(
                          email: _email, password: _password);
                      if (!context.mounted) return;
                      setState(() {
                        _setHasError(
                            boolean: response["isSuccess"] ? false : true);
                      });
                      _showMessage(response["message"]);
                    },
                  ),
                  // ログインボタン
                  ElevatedButton(
                      style: AuthButton.style,
                      child: const Text('ログイン', style: elevatedButtonTextStyle),
                      onPressed: () async {
                        // メール・パスワードでログイン
                        final Map<dynamic, dynamic> response =
                            await authController.login(
                          email: _email,
                          password: _password,
                        );
                        if (response["isSuccess"]) {
                          debugPrint("ユーザ認証に成功しました");
                          // ログインに成功したので，ホーム画面に遷移する．
                          if (!context.mounted) return;
                          context.push('/my-page');
                        } else {
                          // ログイン失敗時の操作
                          setState(() {
                            _setHasError(boolean: true);
                          });
                          _showMessage(response["message"]);
                        }
                      }),
                  // パスワードリセットボタン
                  ElevatedButton(
                      style: AuthButton.style,
                      child: const Text('パスワードリセット',
                          style: elevatedButtonTextStyle),
                      onPressed: () async {
                        final response = await authController
                            .sendPasswordResetEmail(email: _email);
                        setState(() {
                          _setHasError(
                              boolean: response["isSuccess"] ? false : true);
                        });
                        _showMessage(response["message"]);
                      }),
                  // メール検証メール送信ボタン
                  ElevatedButton(
                    style: AuthButton.style,
                    child: const Text('メール検証メール送信',
                        style: elevatedButtonTextStyle),
                    onPressed: () async {
                      final response =
                          await authController.sendEmailVerification(
                        email: _email,
                        password: _password,
                      );
                      if (!context.mounted) {
                        return;
                      }
                      debugPrint("メール検証メール送信ボタンが押されました: $response");
                      setState(() {
                        _setHasError(
                            boolean: response["isSuccess"] ? false : true);
                      });
                      _showMessage(response["message"]);
                    },
                  ),
                ])),
      ),
    );
  }
}
