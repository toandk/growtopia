import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growtopia/theme/colors.dart';

class AppThemes {
  static String get _mainFontFamily {
    return GetPlatform.isAndroid ? 'BoldenVan' : 'BoldenVan';
  }

  static String get gameFont {
    return 'BoldenVan';
  }

  static FontWeight get _fontWeightMediumOrSemibold {
    return kIsWeb
        ? FontWeight.w500
        : (GetPlatform.isAndroid ? FontWeight.w500 : FontWeight.w600);
  }

  static ThemeData instance = _lightTheme;

  // LIGHT THEME TEXT
  static final TextTheme _lightTextTheme = TextTheme(
    displayLarge: TextStyle(
        fontSize: 40.0,
        fontFamily: _mainFontFamily,
        fontWeight: FontWeight.bold,
        height: 60.0 / 40.0,
        color: GPColor.contentPrimary),
    displayMedium: TextStyle(
        fontSize: 32.0,
        fontFamily: _mainFontFamily,
        fontWeight: FontWeight.bold,
        height: 50.0 / 32.0,
        color: GPColor.contentPrimary),
    displaySmall: TextStyle(
        fontSize: 24,
        fontFamily: _mainFontFamily,
        fontWeight: FontWeight.w500,
        height: 40.0 / 24.0,
        color: GPColor.contentPrimary),
    headlineMedium: TextStyle(
        fontSize: 28.0,
        fontFamily: _mainFontFamily,
        fontWeight: _fontWeightMediumOrSemibold,
        height: 36.0 / 28.0,
        color: GPColor.contentPrimary),
    headlineSmall: TextStyle(
        fontSize: 24.0,
        fontFamily: _mainFontFamily,
        fontWeight: _fontWeightMediumOrSemibold,
        height: 32.0 / 24.0,
        color: GPColor.contentPrimary),
    titleLarge: TextStyle(
        fontSize: 20.0,
        fontFamily: _mainFontFamily,
        fontWeight: _fontWeightMediumOrSemibold,
        height: 28.0 / 20.0,
        color: GPColor.contentPrimary),
    titleMedium: TextStyle(
        fontSize: 20.0,
        fontFamily: _mainFontFamily,
        fontWeight: FontWeight.normal,
        height: 32.0 / 20.0,
        color: GPColor.contentPrimary),
    titleSmall: TextStyle(
        fontSize: 16.0,
        fontFamily: _mainFontFamily,
        fontWeight: _fontWeightMediumOrSemibold,
        height: 24.0 / 16.0,
        color: GPColor.contentPrimary),
    bodySmall: TextStyle(
        fontSize: 14.0,
        fontFamily: _mainFontFamily,
        fontWeight: _fontWeightMediumOrSemibold,
        height: 20.0 / 14.0,
        color: GPColor.contentPrimary),
    bodyLarge: TextStyle(
      fontSize: 16.0,
      fontFamily: _mainFontFamily,
      fontWeight: FontWeight.normal,
      height: 26.0 / 16.0,
      color: GPColor.contentPrimary,
    ),
    bodyMedium: TextStyle(
      fontSize: 14.0,
      fontFamily: _mainFontFamily,
      height: 20.0 / 14.0,
      color: GPColor.contentPrimary,
    ),
    labelSmall: TextStyle(
      fontSize: 12.0,
      fontFamily: _mainFontFamily,
      height: 16.0 / 12.0,
      color: GPColor.contentPrimary,
    ),
    labelLarge: TextStyle(
      fontSize: 18.0,
      fontFamily: _mainFontFamily,
      fontWeight: FontWeight.bold,
      height: 32.0 / 18.0,
      color: GPColor.contentPrimary,
    ),
  );

  // DARK THEME TEXT
  static final TextTheme _darkTextTheme = TextTheme(
    displayLarge: TextStyle(
        fontSize: 40.0,
        fontFamily: _mainFontFamily,
        fontWeight: FontWeight.bold,
        height: 60.0 / 40.0,
        leadingDistribution: TextLeadingDistribution.even,
        color: GPColor.darkContentPrimary),
    displayMedium: TextStyle(
        fontSize: 32.0,
        fontFamily: _mainFontFamily,
        fontWeight: FontWeight.bold,
        height: 50.0 / 32.0,
        leadingDistribution: TextLeadingDistribution.even,
        color: GPColor.darkContentPrimary),
    displaySmall: TextStyle(
        fontSize: 24.0,
        fontFamily: _mainFontFamily,
        fontWeight: FontWeight.bold,
        height: 40.0 / 24.0,
        leadingDistribution: TextLeadingDistribution.even,
        color: GPColor.darkContentPrimary),
    headlineMedium: TextStyle(
        fontSize: 28.0,
        fontFamily: _mainFontFamily,
        fontWeight: _fontWeightMediumOrSemibold,
        height: 36.0 / 28.0,
        color: GPColor.darkContentPrimary),
    headlineSmall: TextStyle(
        fontSize: 24.0,
        fontFamily: _mainFontFamily,
        fontWeight: _fontWeightMediumOrSemibold,
        height: 32.0 / 24.0,
        color: GPColor.darkContentPrimary),
    titleLarge: TextStyle(
        fontSize: 20.0,
        fontFamily: _mainFontFamily,
        fontWeight: _fontWeightMediumOrSemibold,
        height: 28.0 / 20.0,
        color: GPColor.darkContentPrimary),
    titleMedium: TextStyle(
        fontSize: 20.0,
        fontFamily: _mainFontFamily,
        fontWeight: FontWeight.normal,
        height: 32.0 / 20.0,
        leadingDistribution: TextLeadingDistribution.even,
        color: GPColor.darkContentPrimary),
    titleSmall: TextStyle(
        fontSize: 16.0,
        fontFamily: _mainFontFamily,
        fontWeight: _fontWeightMediumOrSemibold,
        height: 24.0 / 16.0,
        leadingDistribution: TextLeadingDistribution.even,
        color: GPColor.darkContentPrimary),
    bodySmall: TextStyle(
        fontSize: 14.0,
        fontFamily: _mainFontFamily,
        fontWeight: _fontWeightMediumOrSemibold,
        height: 20.0 / 14.0,
        leadingDistribution: TextLeadingDistribution.even,
        color: GPColor.darkContentPrimary),
    bodyLarge: TextStyle(
      fontSize: 16.0,
      fontFamily: _mainFontFamily,
      fontWeight: FontWeight.normal,
      height: 26.0 / 16.0,
      leadingDistribution: TextLeadingDistribution.even,
      color: GPColor.darkContentPrimary,
    ),
    bodyMedium: TextStyle(
      fontSize: 14.0,
      fontFamily: _mainFontFamily,
      height: 20.0 / 14.0,
      leadingDistribution: TextLeadingDistribution.even,
      color: GPColor.darkContentPrimary,
    ),
    labelSmall: TextStyle(
      fontSize: 12.0,
      fontFamily: _mainFontFamily,
      height: 16.0 / 12.0,
      color: GPColor.darkContentPrimary,
    ),
    labelLarge: TextStyle(
      fontSize: 18.0,
      fontFamily: _mainFontFamily,
      fontWeight: FontWeight.bold,
      leadingDistribution: TextLeadingDistribution.even,
      height: 32.0 / 18.0,
      color: GPColor.darkContentPrimary,
    ),
  );

  // LIGHT THEME
  static final ThemeData _lightTheme = ThemeData(
    fontFamily: _mainFontFamily,
    primaryColor: GPColor.workPrimary,
    scaffoldBackgroundColor: GPColor.bgPrimary,
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: GPColor.workPrimary,
    ),
    appBarTheme: const AppBarTheme(
      color: GPColor.bgPrimary,
      iconTheme: IconThemeData(color: GPColor.contentPrimary),
    ),
    colorScheme: const ColorScheme.light(
      primary: GPColor.workPrimary,
      secondary: GPColor.bgSecondary,
    ),
    snackBarTheme:
        const SnackBarThemeData(backgroundColor: GPColor.contentPrimary),
    iconTheme: const IconThemeData(
      color: GPColor.contentInversePrimary,
    ),
    popupMenuTheme: const PopupMenuThemeData(color: GPColor.bgPrimary),
    textTheme: _lightTextTheme,
  );

  // DARK THEME
  static final ThemeData _darkTheme = ThemeData(
    brightness: Brightness.dark,
    fontFamily: _mainFontFamily,
    primaryColor: GPColor.workPrimary,
    scaffoldBackgroundColor: GPColor.darkBgPrimary,
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: GPColor.workPrimary,
    ),
    appBarTheme: const AppBarTheme(
      color: GPColor.darkBgPrimary,
      iconTheme: IconThemeData(color: GPColor.contentSecondary),
    ),
    colorScheme: const ColorScheme.dark(
      primary: GPColor.bgInversePrimary,
      secondary: GPColor.bgSecondary,
    ),
    snackBarTheme:
        const SnackBarThemeData(backgroundColor: GPColor.bgSecondary),
    iconTheme: const IconThemeData(
      color: GPColor.bgInversePrimary,
    ),
    popupMenuTheme: const PopupMenuThemeData(color: GPColor.bgInversePrimary),
    textTheme: _darkTextTheme,
  );

  /// LIGHT THEME
  static ThemeData lightTheme() {
    return _lightTheme;
  }

  /// DARK THEME
  static ThemeData darktheme() {
    return _darkTheme;
  }
}
