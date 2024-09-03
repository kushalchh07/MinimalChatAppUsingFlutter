import 'package:flutter/material.dart';

import 'package:flutter/scheduler.dart';

import '../constants/colors/colors.dart';

class AppTheme {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return isDarkTheme ? ThemeColors.darkTheme : ThemeColors.lightTheme;
  }
}

class ThemeColors {
  const ThemeColors._();

  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    fontFamily: 'Poppins',
    primaryColor: primaryColor,
    scaffoldBackgroundColor: lightBackgroundColor,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    appBarTheme: AppBarTheme(
      backgroundColor: lightBackgroundColor,
    ),
    textTheme: TextTheme(
      labelLarge: TextStyle(color: lightTextColor),
    ),
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: primaryColor,
      onPrimary: Colors.white,
      secondary: secondaryColor,
      onSecondary: Colors.white,
      error: Colors.red,
      onError: Colors.white,
      background: lightBackgroundColor,
      onBackground: lightTextColor,
      surface: lightBackgroundColor,
      onSurface: lightTextColor,
    ),
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    fontFamily: 'Poppins',
    primaryColor: primaryColor,
    scaffoldBackgroundColor: const Color(0xFF00040F),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    appBarTheme: AppBarTheme(
      backgroundColor: darkBackgroundColor,
    ),
    textTheme: TextTheme(
      labelLarge: TextStyle(color: darkTextColor),
    ),
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: primaryColor,
      onPrimary: Colors.black,
      secondary: secondaryColor,
      onSecondary: Colors.black,
      error: Colors.red,
      onError: Colors.black,
      background: darkBackgroundColor,
      onBackground: darkTextColor,
      surface: darkBackgroundColor,
      onSurface: darkTextColor,
    ),
  );

  static Brightness get currentSystemBrightness =>
      SchedulerBinding.instance.window.platformBrightness;
}

extension ThemeExtras on ThemeData {
  Color get navBarColor => brightness == Brightness.light
      ? const Color(0xffF0F0F0)
      : const Color(0xFF00040F);

  Color get textColor => brightness == Brightness.light
      ? const Color(0xFF403930)
      : const Color(0xFFFFF8F2);

  Color get secondaryColor => const Color.fromARGB(255, 157, 155, 156);

  // Gradient get serviceCard =>
  //     brightness == Brightness.light ? grayWhite : grayBack;

  // Gradient get contactCard =>
  //     brightness == Brightness.light ? grayWhite : contactGradi;
}
