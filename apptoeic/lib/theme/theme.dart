import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    background: Colors.grey.shade100,
    primary: const Color.fromRGBO(38, 52, 114, 1),
    secondary: Colors.grey,
    tertiary: Colors.white,
    outline: Colors.black87,
  )
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    background: Color.fromRGBO(3, 21, 37, 1),
    primary: Color.fromRGBO(211, 227, 253, 1),
    secondary: Colors.white70,
    tertiary: Color.fromRGBO(38, 58, 114, 1),
    outline: Colors.white,
  )
);