import 'package:cook_helper_mobile_app/views/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:gap/gap.dart';
// utils
import '../utils/page_title.dart';
import '../utils/colors.dart';

// models
import '../../models/recipe_model.dart';

class RecipeDetailPage extends StatefulWidget {
  final Recipe recipe;
  const RecipeDetailPage({super.key, required this.recipe});
  @override
  State<RecipeDetailPage> createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CommonColors.pageBackgroundColor,
        appBar: AppBar(
          title: PageTitle(pageTitleName: widget.recipe.dishName ?? ""),
          backgroundColor: CommonColors.primaryColor,
        ),
        body: SingleChildScrollView(
            child: Center(
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('Recipe Page Content'),
                const Gap(100),
                Text('料理名: ${widget.recipe.recipeType}'),
                const Gap(10),
                if (widget.recipe.recipeType != "Original Recipe") ...{
                  const Divider(),
                  SizedBox(
                    height: 1000,
                    child: WebViewContainer(
                        recipeUrl: widget.recipe.url ?? "",
                        recipeDishName: widget.recipe.dishName ?? ""),
                  ),
                }
              ]),
        )));
  }
}

class WebViewContainer extends StatefulWidget {
  final String recipeUrl;
  final String recipeDishName;
  const WebViewContainer({
    super.key,
    required this.recipeUrl,
    required this.recipeDishName,
  });

  @override
  State<WebViewContainer> createState() => _WebViewContainerState();
}

class _WebViewContainerState extends State<WebViewContainer> {
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
        title: const Text("登録したレシピのサイトページ"),
        backgroundColor: Colors.white,
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
