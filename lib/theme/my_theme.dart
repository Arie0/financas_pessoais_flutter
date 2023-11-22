import 'package:financas_pessoais_flutter/theme/my_colors.dart';
import 'package:flutter/material.dart';

class MyTheme {
  static final lightTheme = ThemeData.light(
    useMaterial3: true,
  ).copyWith(
    primaryColor: MyColors.primaryColor,
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      backgroundColor: MyColors.primaryColor,
    ),
    elevatedButtonTheme: const ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(
          MyColors.primaryColor,
        ),
        textStyle: MaterialStatePropertyAll(
          TextStyle(
            color: MyColors.textLight,
          ),
        ),
      ),
    ),
    textButtonTheme: const TextButtonThemeData(
      style: ButtonStyle(
        textStyle: MaterialStatePropertyAll(
          TextStyle(
            color: Color.fromARGB(255, 107, 97, 97),
          ),
        ),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color.fromARGB(255, 129, 77, 160)),
  );

  static final darkTheme = ThemeData.dark(
    useMaterial3: true,
  );
}