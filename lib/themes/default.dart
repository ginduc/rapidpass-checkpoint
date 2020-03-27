import 'package:flutter/material.dart';

final Color deepPurple300 = Color(0xff9575CD);
final Color deepPurple600 = Color(0xff5E35B1);
final Color deepPurple900 = Color(0xff311B92);
final Color green300 = Color(0xff81C784);

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
