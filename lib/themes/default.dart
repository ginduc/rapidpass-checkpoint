import 'package:flutter/material.dart';

final Color deepPurple300 = const Color(0xff9575CD);
final Color deepPurple600 = const Color(0xff5E35B1);
final Color deepPurple900 = const Color(0xff311B92);
final Color green300 = const Color(0xff81C784);

final ColorScheme light = ColorScheme.light();
final ColorScheme rapidPassColorScheme = ColorScheme(
    background: light.background,
    brightness: light.brightness,
    error: light.error,
    onError: light.onError,
    onPrimary: light.onPrimary,
    onSecondary: light.onSecondary,
    onSurface: light.onSurface,
    onBackground: light.onBackground,
    primary: deepPurple900,
    primaryVariant: Colors.deepPurpleAccent,
    secondary: green300,
    secondaryVariant: Colors.greenAccent,
    surface: light.surface);

class Purple {
  static ThemeData buildFor(BuildContext context) {
    final themeData = Theme.of(context);
    final colorScheme = themeData.colorScheme.copyWith(
        surface: deepPurple900,
        background: deepPurple900,
        primary: deepPurple900,
        primaryVariant: green300,
        onPrimary: Colors.white,
        onSurface: Colors.white,
        onBackground: Colors.white,
        onError: Colors.white,
        onSecondary: Colors.white);
    final textTheme = themeData.textTheme.apply(bodyColor: Colors.white);
    final primaryTextTheme =
        themeData.primaryTextTheme.apply(bodyColor: Colors.white);
    return themeData.copyWith(
        buttonTheme: themeData.buttonTheme.copyWith(
            buttonColor: green300,
            colorScheme: colorScheme,
            textTheme: ButtonTextTheme.accent),
        textTheme: textTheme,
        primaryTextTheme: primaryTextTheme);
  }
}

class Green {
  static ThemeData buildFor(BuildContext context) {
    final themeData = Theme.of(context);
    final colorScheme = themeData.colorScheme
        .copyWith(surface: green300, primary: deepPurple900);
    return themeData.copyWith(
        buttonTheme: themeData.buttonTheme.copyWith(
            buttonColor: green300,
            colorScheme: colorScheme,
            textTheme: ButtonTextTheme.accent));
  }
}
