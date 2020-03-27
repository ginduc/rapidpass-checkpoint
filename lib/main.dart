import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rapidpass_checkpoint/screens/control_no.dart';
import 'package:rapidpass_checkpoint/screens/main_menu.dart';
import 'package:rapidpass_checkpoint/screens/pass_ok.dart';
import 'package:rapidpass_checkpoint/screens/plate_no.dart';
import 'package:rapidpass_checkpoint/screens/welcome_screen.dart';
import 'package:rapidpass_checkpoint/viewmodel/device_info_model.dart';

void main() => runApp(RapidPassCheckpointApp());

class RapidPassCheckpointApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Provide the model here
        ChangeNotifierProvider(
          create: (_) => DeviceInfoModel(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
        initialRoute: "/",
        routes: {'/': (_) => WelcomeScreen()},
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/menu':
              return CupertinoPageRoute(
                  builder: (_) => MainMenuScreen(checkPointName: 'Camp Aguinaldo', openScan: false), //MainMenuScreen('Camp Aguinaldo', false),
                  settings: settings);
            case '/passOk':
              return CupertinoPageRoute(
                  builder: (_) => PassOkScreen(settings.arguments),
                  settings: settings);
            case '/checkPlateNumber':
              return CupertinoPageRoute(
                  builder: (_) => PlateNoScreen(title: 'Check Plate Number'),
                  settings: settings);
            case '/checkControlCode':
              return CupertinoPageRoute(
                  builder: (_) => ControlNoScreen(title: 'Check Control Number'),
                  settings: settings);

                  
          }
          return null;
        },
      ),
    );
  }
}
