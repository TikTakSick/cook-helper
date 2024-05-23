import 'package:flutter/material.dart';

// ui_setting
import 'text_styles.dart';

class PageTitle extends StatelessWidget {
  final String pageTitleName;
  const PageTitle({super.key, required this.pageTitleName});

  @override
  build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      const Icon(Icons.restaurant, size: 30),
      Text(pageTitleName, style: pageTitleTextStyle),
      const Icon(Icons.restaurant, size: 30),
    ]);
  }
}
