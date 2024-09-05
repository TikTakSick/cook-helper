import 'package:flutter/material.dart';

// ui_setting
import 'text_styles.dart';

class PageTitleBase extends StatelessWidget {
  final String pageTitleName;
  final int maxCharacters = 10; // 表示する文字数を10に制限
  const PageTitleBase({
    super.key,
    required this.pageTitleName,
  });

  @override
  Widget build(BuildContext context) {
    // テキストの長さがmaxCharactersを超えた場合、超えた部分を切り捨てて省略記号を追加
    String displayedPageTitleName = pageTitleName.length > maxCharacters
        ? '${pageTitleName.substring(0, maxCharacters)}...'
        : pageTitleName;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.restaurant, size: 30),
        Text(
          displayedPageTitleName,
          style: pageTitleTextStyle,
        ),
        const Icon(Icons.restaurant, size: 30),
      ],
    );
  }
}

class PageTitle extends StatelessWidget {
  final String pageTitleName;
  final int maxCharacters = 10; // 表示する文字数を10に制限
  const PageTitle({
    super.key,
    required this.pageTitleName,
  });

  @override
  Widget build(BuildContext context) {
    // テキストの長さがmaxCharactersを超えた場合、超えた部分を切り捨てて省略記号を追加
    String displayedPageTitleName = pageTitleName.length > maxCharacters
        ? '${pageTitleName.substring(0, maxCharacters)}...'
        : pageTitleName;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.restaurant, size: 30),
        Text(
          displayedPageTitleName,
          style: pageTitleTextStyle,
        ),
        const Icon(Icons.restaurant, size: 30),
      ],
    );
  }
}
