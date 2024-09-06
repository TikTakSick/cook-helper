import 'package:flutter/material.dart';
import 'colors.dart';

class AuthButton {
  static ButtonStyle style = ElevatedButton.styleFrom(
    fixedSize: const Size(400, 1),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(0),
    ),
    side: const BorderSide(color: CommonColors.subprimaryColor),
    backgroundColor: CommonColors.primaryColor,
    foregroundColor: Colors.black,
  );
}

class SettingPageButton {
  static ButtonStyle style = ElevatedButton.styleFrom(
    fixedSize: const Size(400, 2),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(0),
    ),
    side: const BorderSide(color: CommonColors.subprimaryColor),
    backgroundColor: CommonColors.primaryColor,
    foregroundColor: Colors.black,
  );
}

class RecipeAddPageButton {
  static ButtonStyle style = ElevatedButton.styleFrom(
    fixedSize: const Size(500, 2),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(0),
    ),
    side: const BorderSide(color: CommonColors.subprimaryColor),
    backgroundColor: CommonColors.primaryColor,
    foregroundColor: Colors.black,
  );
}

class RecipeDetailPageButton {
  static ButtonStyle style = ElevatedButton.styleFrom(
    fixedSize: const Size(400, 1),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(0),
    ),
    side: const BorderSide(color: CommonColors.subprimaryColor),
    backgroundColor: CommonColors.primaryColor,
    foregroundColor: Colors.black,
  );
}

class RecipeEditPageButton {
  static ButtonStyle style = ElevatedButton.styleFrom(
    fixedSize: const Size(400, 1),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(0),
    ),
    side: const BorderSide(color: CommonColors.subprimaryColor),
    backgroundColor: CommonColors.primaryColor,
    foregroundColor: Colors.black,
  );
}

class DialogButton {
  static ButtonStyle style = OutlinedButton.styleFrom(
      backgroundColor: CommonColors.primaryColor,
      textStyle: const TextStyle(color: CommonColors.textColor),
      side: const BorderSide(color: CommonColors.subprimaryColor));
}
