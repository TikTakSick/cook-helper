import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:gap/gap.dart';
// utils
import '../utils/colors.dart';
import '../utils/page_title.dart';

class RecipeWebSitePage extends StatefulWidget {
  final String recipeUrl;
  final String recipeDishName;
  const RecipeWebSitePage({
    super.key,
    required this.recipeUrl,
    required this.recipeDishName,
  });

  @override
  State<RecipeWebSitePage> createState() => _RecipeWebSitePageState();
}

class _RecipeWebSitePageState extends State<RecipeWebSitePage> {
  var loadingPercentage = 0;
  var isLoading = true;
  var hasError = false;
  // WebViewWidgetControllerのインスタンスを作成
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setNavigationDelegate(NavigationDelegate(onPageStarted: (url) {
        setState(() {
          loadingPercentage = 0;
          isLoading = true;
          hasError = false;
        });
      }, onProgress: (progress) {
        setState(() {
          loadingPercentage = progress;
        });
      }, onPageFinished: (url) {
        setState(() {
          loadingPercentage = 100;
          isLoading = false;
        });
      }, onWebResourceError: (error) {
        setState(() {
          debugPrint(error.toString());
          hasError = true;
          isLoading = false;
        });
      }))
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(
        Uri.parse(widget.recipeUrl),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: PageTitle(pageTitleName: widget.recipeDishName),
        backgroundColor: CommonColors.primaryColor,
      ),
      body: hasError
          // エラーが発生した場合の表示
          ? Container(
              color: CommonColors.pageBackgroundColor,
              child: Center(
                  child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Gap(20),
                  const Text(
                    'ページの読み込みに失敗しました。',
                    style: TextStyle(color: Colors.red, fontSize: 20),
                  ),
                  const Gap(20),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        hasError = false;
                        isLoading = true;
                      });
                      controller.loadRequest(Uri.parse(widget.recipeUrl));
                    },
                    child: const Text('再度ページを読み込む'),
                  ),
                ],
              )),
            )
          // エラーが発生していない場合の表示
          : Stack(
              children: [
                WebViewWidget(
                  controller: controller,
                ),
                if (isLoading)
                  LinearProgressIndicator(
                    value: loadingPercentage / 100.0,
                  ),
              ],
            ),
    );
  }
}
