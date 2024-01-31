import 'package:flutter/material.dart';

import '../../Widgets/starlink/colors.dart';
import '../Values/colors.dart';

class ThemeApp {
  static const _backgroundColorLight = Color(0xffEEEEEE);

  static ThemeData themeLight = ThemeData(
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: StarlinkColors.white,
      selectionColor: StarlinkColors.gray,
      selectionHandleColor: StarlinkColors.white,
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: StarlinkColors.black,
    ),
    fontFamily: 'DDIN',
    colorScheme: const ColorScheme(
      primary: StarlinkColors.black,
      secondary: StarlinkColors.gray,
      surface: StarlinkColors.black,
      background: _backgroundColorLight,
      error: StarlinkColors.red,
      onPrimary: StarlinkColors.black,
      onSecondary: StarlinkColors.lightGray,
      onSurface: StarlinkColors.black,
      onBackground: StarlinkColors.black,
      onError: StarlinkColors.red,
      brightness: Brightness.light,
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: ColorsApp.grey,
      contentTextStyle: TextStyle(color: Colors.white),
      behavior: SnackBarBehavior.floating,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(ColorsApp.grey),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        textStyle: MaterialStateProperty.all(
          const TextStyle(
            fontFamily: 'DDIN-Bold',
            fontWeight: FontWeight.bold,
            color: StarlinkColors.gray,
          ),
        ),
      ),
    ),
    scaffoldBackgroundColor: _backgroundColorLight,
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0),
        borderSide: BorderSide.none,
      ),
      fillColor: StarlinkColors.white.withOpacity(.8),
      filled: true,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 25.0,
      ),
      hintStyle: const TextStyle(
        color: ColorsApp.textColor,
      ),
    ),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      titleTextStyle: TextStyle(
          color: StarlinkColors.white,
          fontFamily: 'DDIN-Bold',
          fontWeight: FontWeight.w600,
          fontSize: 26),
      backgroundColor: StarlinkColors.black,
    ),
    textTheme: const TextTheme(
      titleMedium: TextStyle(
        color: ColorsApp.textColor,
        fontFamily: 'DDIN-Bold',
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}

extension CustomTheme on ThemeData {}
