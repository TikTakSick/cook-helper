import 'package:flutter/material.dart';

class CommonColors {
  static const MaterialColor primaryColor =
      MaterialColor(0xFFC9A99A, <int, Color>{
    50: Color(0xFFF9F5F3),
    100: Color(0xFFEFE5E1),
    200: Color(0xFFE4D4CD),
    300: Color(0xFFD9C3B8),
    400: Color(0xFFD1B6A9),
    500: Color(0xFFC9A99A), // use this color as primary color of widgets
    600: Color(0xFFC3A292),
    700: Color(0xFFBC9888),
    800: Color(0xFFB58F7E),
    900: Color(0xFFA97E6C),
  });

  static const MaterialColor subprimaryColor =
      MaterialColor(0xFFC95C43, <int, Color>{
    50: Color(0xFFF9EBE8),
    100: Color(0xFFEFCEC7),
    200: Color(0xFFE4AEA1),
    300: Color(0xFFD98D7B),
    400: Color(0xFFD1745F),
    500: Color(0xFFC95C43),
    600: Color(0xFFC3543D),
    700: Color(0xFFBC4A34),
    800: Color(0xFFB5412C), // use this color as subprimary color of widgets
    900: Color(0xFFA9301E),
  });
}
