import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rapidpass_checkpoint/screens/main_menu.dart';
import 'package:rapidpass_checkpoint/screens/result.dart';
import 'package:rapidpass_checkpoint/screens/pass_ok.dart';
import 'package:rapidpass_checkpoint/screens/welcome_screen.dart';
import 'package:rapidpass_checkpoint/viewmodel/device_info_model.dart';

import 'screens/pass_ok.dart';
import 'screens/welcome_screen.dart';
import 'themes/default.dart';

void main() => runApp(RapidPassCheckpointApp());

class RapidPassCheckpointApp extends StatelessWidget {
  final tableData = {
      'Control Code': '2A8B043',
      'Plate Number:': 'ABC 1234',
      'Access Type:': 'Medical (M)',
      'Valid From:': 'March 23, 2020',
      'Valid Until:': 'March 27, 2020',
    };
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
        routes: {'/': (_) => //  Result(null, tableData, red400, 'assets/check-2x.png', 'Entry Approved', ''),
        WelcomeScreen()},
      //  Result(null, tableData, green300, 'assets/check-2x.png', 'Entry Approved', ''),
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/menu':
              return CupertinoPageRoute(
                  builder: (_) => MainMenuScreen('Camp Aguinaldo'),
                  settings: settings);
            case '/passOk':
              return CupertinoPageRoute(
                  builder: (_) => PassOkScreen(settings.arguments),
                  settings: settings);
          case '/passFail':
          return CupertinoPageRoute(
          //  builder: (_)=>Result(qrData, tableData, headerColor, headerIcon, headerText, headerSubtext),
            settings: settings);
    
          }
          return null;
        },
      ),
    );
  }
}
