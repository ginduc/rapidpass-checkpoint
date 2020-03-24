import 'package:flutter/material.dart';
import 'package:rapidpass_checkpoint/screens/main_menu.dart';
import 'package:rapidpass_checkpoint/screens/welcome_screen.dart';

void main() => runApp(RapidPassCheckpointApp());

class RapidPassCheckpointApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => WelcomeScreen(),
        "/menu": (context) => MainMenuScreen("Camp Aguinaldo")
      },
    );
  }
}
