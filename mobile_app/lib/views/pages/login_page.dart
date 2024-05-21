import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gap/gap.dart';

import 'home_page.dart';
import '../ui_settings/ui_colors.dart';
import "../ui_settings/ui_buttonstyles.dart";
import "../ui_settings/ui_textstyles.dart";

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email = '';
  String _password = '';
  String message = '';
  String infoMessage = '';
  bool isError = false;
  final String title = "Cook Helper Login Page";

  void set_infoMessage(message) {
    setState(() {
      infoMessage = message;
    });
  }

  void set_isError({boolean = true}) {
    setState(() {
      isError = boolean;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CommonColors.pageBackgroundColor,
      appBar: AppBar(
        title: Text(title, style: pageTitleTextStyle),
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
                child:
                    const Text('ユーザ登録（サインアップ）', style: elevatedButtonTextStyle),
                onPressed: () async {
                  try {
                    final User? user = (await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                                email: _email, password: _password))
                        .user;
                    if (user != null) {
                      print("ユーザ登録しました:\n ${user.email} , ${user.uid}");
                      // ユーザ登録に成功したので，ホーム画面に遷移する．
                      await Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) {
                          return HomePage();
                        }),
                      );
                    }
                  } on FirebaseAuthException catch (error) {
                    set_isError(boolean: true);
                    set_infoMessage(error.message.toString());
                  }
                },
              ),
              // ログインボタン
              ElevatedButton(
                  style: AuthButton.style,
                  child: const Text('ログイン', style: elevatedButtonTextStyle),
                  onPressed: () async {
                    try {
                      // メール/パスワードでログイン
                      final User? user = (await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                  email: _email, password: _password))
                          .user;
                      if (user != null) {
                        print("ログインしました:\n ${user.email} , ${user.uid}");
                        // ログイン成功したので，ホーム画面に遷移．
                        await Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) {
                            return HomePage();
                          }),
                        );
                      }
                    } on FirebaseAuthException catch (error) {
                      set_isError(boolean: true);
                      set_infoMessage(error.message.toString());
                    }
                  }),
              // パスワードリセットボタン
              ElevatedButton(
                  style: AuthButton.style,
                  child:
                      const Text('パスワードリセット', style: elevatedButtonTextStyle),
                  onPressed: () async {
                    try {
                      await FirebaseAuth.instance
                          .sendPasswordResetEmail(email: _email);
                      message = "パスワードリセット用のメールを送信しました";
                      set_isError(boolean: false);
                    } on FirebaseAuthException catch (error) {
                      message = error.message.toString();
                      set_isError(boolean: true);
                    }
                    set_infoMessage(message);
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
