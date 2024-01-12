import 'package:flutter/material.dart';

import '../Values/Colors.dart';

class ThemeApp{
  static const _backgroundColorLight = Color(0xffEEEEEE);

  static ThemeData themeLight = ThemeData(
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Color(0xff123258),

    ),
    fontFamily: 'DDIN',
    colorScheme:const ColorScheme(
      primary: StarlinkColors.black,
      secondary: StarlinkColors.gray,
      surface: Colors.black,
      background: _backgroundColorLight,
      error: StarlinkColors.red,
      onPrimary: Colors.black,
      onSecondary: ColorsApp.secondary,
      onSurface: Colors.black,
      onBackground: Colors.black,
      onError: ColorsApp.alert,
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
            color: Colors.grey,
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
      fillColor: Colors.white.withOpacity(.8),
      filled: true,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 25.0,
      ),
      hintStyle: const TextStyle(
        color: ColorsApp.textColor,
      ),
    ),
    appBarTheme: AppBarTheme(
      centerTitle: true,
      titleTextStyle: const TextStyle(
        color: ColorsApp.primary,
        fontFamily: 'DDIN-Bold',
        fontWeight: FontWeight.w600,
        fontSize: 26
      ),
      backgroundColor: ColorsApp.secondary.withOpacity(.8),
    ),
    textTheme: const TextTheme(
      subtitle1: TextStyle(
        color: ColorsApp.textColor,
        fontFamily: 'DDIN-Bold',
        fontWeight: FontWeight.w600,
      ),

    ),
  );

}

extension CustomTheme on ThemeData{

}