import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moor_flutter/moor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rapidpass_checkpoint/data/app_database.dart';
import 'package:rapidpass_checkpoint/repository/api_respository.dart';
import 'package:rapidpass_checkpoint/screens/check_plate_or_control_results_screen.dart';
import 'package:rapidpass_checkpoint/screens/check_plate_or_control_screen.dart';
import 'package:rapidpass_checkpoint/screens/main_menu.dart';
import 'package:rapidpass_checkpoint/screens/qr_scanner_screen.dart';
import 'package:rapidpass_checkpoint/screens/scan_result_screen.dart';
import 'package:rapidpass_checkpoint/screens/view_more_info_screen.dart';
import 'package:rapidpass_checkpoint/screens/welcome_screen.dart';
import 'package:rapidpass_checkpoint/screens/qr_scanner_screen.dart';
import 'package:rapidpass_checkpoint/services/api_service.dart';
import 'package:rapidpass_checkpoint/services/local_database_service.dart';
import 'package:rapidpass_checkpoint/services/location_service.dart';
import 'package:rapidpass_checkpoint/viewmodel/device_info_model.dart';
import 'package:http/http.dart';

import 'models/check_plate_or_control_args.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((_) => runApp(RapidPassCheckpointApp()));
}

class RapidPassCheckpointApp extends StatelessWidget {
  // TODO: Create separate runnable environment for the main app
  // REST
  Client _client = Client();
  String _rapidPassApiUrl = 'https://api.test.rapidpass.amihan.net/api/v1';

  // Local
  static const String databaseName = 'rapid_pass.sqlite';
  LocalDatabaseService _localDatabaseService = LocalDatabaseService(
    appDatabase: AppDatabase(
      FlutterQueryExecutor.inDatabaseFolder(path: databaseName),
    ),
  );

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Provide the model here
        ChangeNotifierProvider(
          create: (_) => DeviceInfoModel(),
        ),
        Provider(
          create: (_) => _localDatabaseService,
        ),
        Provider(
          create: (_) => ApiRepository(
            apiService: ApiService(
              client: _client,
              baseUrl: _rapidPassApiUrl,
            ),
            localDatabaseService: _localDatabaseService,
          ),
        ),
        StreamProvider(
          create: (_) => LocationService().locationStream,
        ),
      ],
      child: MaterialApp(
        title: 'RapidPass Checkpoint',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          appBarTheme: AppBarTheme(
            textTheme: GoogleFonts.workSansTextTheme(
              Theme.of(context).textTheme,
            ).copyWith(
              title: GoogleFonts.workSans(
                textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          textTheme: GoogleFonts.workSansTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        initialRoute: "/",
        routes: {WelcomeScreen.routeName: (_) => WelcomeScreen()},
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case MainMenuScreen.routeName:
              return CupertinoPageRoute(
                builder: (_) => MainMenuScreen(),
                settings: settings,
              );
            case ScanResultScreen.routeName:
              return CupertinoPageRoute(
                builder: (_) => ScanResultScreen(settings.arguments),
                settings: settings,
              );
            case CheckPlateOrControlCodeResultsScreen.routeName:
              return CupertinoPageRoute(
                  builder: (_) =>
                      CheckPlateOrControlCodeResultsScreen(settings.arguments),
                  settings: settings);
            case CheckPlateOrControlScreen.routeNamePlateNumber:
              return CupertinoPageRoute(
                builder: (_) {
                  return CheckPlateOrControlScreen(
                      CheckPlateOrControlScreenModeType.plate);
                },
              );
            case CheckPlateOrControlScreen.routeNameControlCode:
              return CupertinoPageRoute(
                builder: (_) {
                  return CheckPlateOrControlScreen(
                      CheckPlateOrControlScreenModeType.control);
                },
              );
            case QrScannerScreen.routeName:
              return CupertinoPageRoute(
                builder: (_) => QrScannerScreen(),
                settings: settings,
              );
            case ViewMoreInfoScreen.routeName:
              return CupertinoPageRoute(
                builder: (_) => ViewMoreInfoScreen(),
                settings: settings,
              );
          }
          return null;
        },
      ),
    );
  }
}
