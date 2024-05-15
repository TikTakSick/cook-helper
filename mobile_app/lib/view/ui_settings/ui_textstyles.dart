import 'package:flutter/material.dart';

import '../ui_settings/ui_colors.dart';

class CommonTextStyle {
  static const TextStyle bottomNavigationBarItemLabelTextStyle =
      TextStyle(fontSize: 15);

  static const TextStyle pageTitleTextStyle = TextStyle(fontSize: 20);

  static const TextStyle dialogButtonTextStyle =
      TextStyle(fontSize: 15, color: CommonColors.textColor);

  static const TextStyle dialogTitleTextStyle = TextStyle(
    fontSize: 15,
    color: CommonColors.textColor,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle elevatedButtonTextStyle = TextStyle(fontSize: 18);
}
