import 'package:flutter/cupertino.dart';
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
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case '/':
            return CupertinoPageRoute(
                builder: (_) => WelcomeScreen(), settings: settings);
          case '/menu':
            return CupertinoPageRoute(
                builder: (_) => MainMenuScreen('Camp Aguinaldo'),
                settings: settings);
        }
        return null;
      },
    );
  }
}
