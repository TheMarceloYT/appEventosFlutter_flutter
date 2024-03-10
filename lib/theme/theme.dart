import 'package:flutter/material.dart';

class ThemeColors{

  //tema claro
  static final ThemeData lightMode = ThemeData(
    brightness: Brightness.light,
    iconTheme: IconThemeData(color: Colors.white),
    colorScheme: ColorScheme.light(
      background: Colors.white,
      primary: Colors.white,
      secondary: Colors.white70,
    ),
  );

  //tema oscuro
  static final ThemeData darkMode = ThemeData(
    brightness: Brightness.dark,
    iconTheme: IconThemeData(color: Colors.black),
    colorScheme: ColorScheme.dark(
      background: Colors.grey.shade900,
      primary: Colors.black,
      secondary: Colors.grey.shade900,
    ),
  );

  
}