import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

// controllers
import "../../controllers/auth_controller.dart";

// views
import 'my_page.dart';

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
  String? message = '';
  String infoMessage = '';
  bool hasError = false;

  final String titleName = "Cook Helper Login Page";

  void _setInfoMessage(message) {
    setState(() {
      infoMessage = message;
    });
  }

  void _setHasError({boolean = true}) {
    setState(() {
      hasError = boolean;
    });
  }

  void _navigateToMyPage({required BuildContext context}) {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
      return const MyPage();
    }));
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
                  // エラーメッセージ表示
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: infoMessage == ""
                        ? null
                        : BoxDecoration(
                            color: CommonColors.primaryColor,
                            border: Border.all(width: 0)),
                    child: Text(
                        hasError ? "エラーが発生しました:\n $infoMessage" : infoMessage,
                        style: const TextStyle(color: Colors.black)),
                  ),
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
                      if (!context.mounted) {
                        return;
                      }
                      setState(() {
                        _setHasError(
                            boolean: response["isSuccess"] ? false : true);
                        _setInfoMessage(response["message"]);
                      });
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
                        if (!context.mounted) {
                          return;
                        }
                        if (response["isSuccess"]) {
                          // ログインに成功したので，ホーム画面に遷移する．
                          debugPrint("ユーザ認証に成功しました");
                          _navigateToMyPage(context: context);
                        } else {
                          // ログイン失敗時の操作
                          setState(() {
                            _setHasError(boolean: true);
                            _setInfoMessage(response["message"]);
                          });
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
                          _setInfoMessage(response["message"]);
                        });
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
                      setState(() {
                        _setHasError(
                            boolean: response["isSuccess"] ? false : true);
                        _setInfoMessage(response["message"]);
                      });
                    },
                  ),
                ])),
      ),
    );
  }
}
