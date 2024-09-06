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
  bool isError = false;

  final String titleName = "Cook Helper Login Page";

  void setInfoMessage(message) {
    setState(() {
      infoMessage = message;
    });
  }

  void setIsError({boolean = true}) {
    setState(() {
      isError = boolean;
    });
  }

  void moveToMyPage({required BuildContext context}) {
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
                        isError ? "エラーが発生しました:\n $infoMessage" : infoMessage,
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
                      if (response["isSuccess"]) {
                        // サインアップに成功したので，ホーム画面に遷移する．
                        if (!context.mounted) {
                          return;
                        }
                        moveToMyPage(context: context);
                      }
                      // サインアップ失敗時の操作
                      else {
                        setState(() {
                          setIsError(boolean: true);
                          setInfoMessage(response["errorMessage"]);
                        });
                      }
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
                          moveToMyPage(context: context);
                        }
                        // ログイン失敗時の操作
                        else {
                          setState(() {
                            setIsError(boolean: true);
                            setInfoMessage(response["errorMessage"]);
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
                        if (response["isSuccess"]) {
                          message = "パスワードリセット用のメールを送信しました";
                          setState(() {
                            setIsError(boolean: false);
                          });
                        } else {
                          message = response["errorMessage"];
                          setIsError(boolean: true);
                        }
                        setInfoMessage(message);
                      })
                ])),
      ),
    );
  }
}
