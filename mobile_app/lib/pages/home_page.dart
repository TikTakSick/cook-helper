import 'package:flutter/material.dart';
import './login_page.dart';
import '../ui_settings/ui_colors.dart';

// ホーム画面用Widget
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Cook Helper'),
          backgroundColor: Common.primaryColor,
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () async {
                // ログイン画面に遷移＋チャット画面を破棄
                await Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) {
                    return const LoginPage();
                  }),
                );
              },
            ),
          ],
        ),
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
