import 'package:flutter/material.dart';
import 'ui_colors.dart';

class AuthButton {
  static ButtonStyle style = ElevatedButton.styleFrom(
    fixedSize: const Size(250, 1),
    side: const BorderSide(color: CommonColors.subprimaryColor),
    backgroundColor: CommonColors.primaryColor,
    foregroundColor: Colors.black,
  );
}
