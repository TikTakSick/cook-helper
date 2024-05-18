import 'package:flutter/material.dart';

import 'ui_colors.dart';

class CommonTextStyle {
  // Page TextStyle
  static const TextStyle pageTitleTextStyle = TextStyle(fontSize: 20);

  // Dialog TextStyle
  static const TextStyle dialogTitleTextStyle =
      TextStyle(fontSize: 25, color: CommonColors.textColor);

  static const TextStyle dialogContentTextStyle =
      TextStyle(fontSize: 15, color: CommonColors.textColor);

  // Button・NavigationBarItem TextStyle
  static const TextStyle elevatedButtonTextStyle = TextStyle(fontSize: 18);

  static const TextStyle dialogButtonTextStyle =
      TextStyle(color: CommonColors.textColor);

  static const TextStyle bottomNavigationBarItemLabelTextStyle =
      TextStyle(fontSize: 17, color: CommonColors.textColor);
}
