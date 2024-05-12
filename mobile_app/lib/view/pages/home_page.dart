import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';
import '../ui_settings/ui_colors.dart';

// ホーム画面用Widget
class HomePage extends StatefulWidget {
  const HomePage(this.user, {super.key});

  final User user;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Cook Helper'),
          backgroundColor: CommonColors.primaryColor,
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                // ログアウト処理
                await FirebaseAuth.instance.signOut();
                // ログイン画面に遷移，ホーム画面を破棄
                await Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) {
                    return const LoginPage();
                  }),
                );
              },
            ),
          ],
        ),
        body: Center(child: Text("ログイン情報：${widget.user}")),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () async {
            // // 投稿画面に遷移
            // await Navigator.of(context).push(
            //   MaterialPageRoute(builder: (context) {
            //     return AddPostPage();
            //   }),
            // );
          },
        ));
  }
}
