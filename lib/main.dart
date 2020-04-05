import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moor/moor.dart';
import 'package:moor_ffi/moor_ffi.dart';
import 'package:path/path.dart' as p;
import 'package:provider/provider.dart';
import 'package:rapidpass_checkpoint/data/app_database.dart';
import 'package:rapidpass_checkpoint/repository/api_repository.dart';
import 'package:rapidpass_checkpoint/screens/about_screen.dart';
import 'package:rapidpass_checkpoint/screens/check_plate_or_control_results_screen.dart';
import 'package:rapidpass_checkpoint/screens/check_plate_or_control_screen.dart';
import 'package:rapidpass_checkpoint/screens/main_menu.dart';
import 'package:rapidpass_checkpoint/screens/qr_scanner_screen.dart';
import 'package:rapidpass_checkpoint/screens/scan_result_screen.dart';
import 'package:rapidpass_checkpoint/screens/view_more_info_screen.dart';
import 'package:rapidpass_checkpoint/screens/welcome_screen.dart';
import 'package:rapidpass_checkpoint/services/api_service.dart';
import 'package:rapidpass_checkpoint/services/local_database_service.dart';
import 'package:rapidpass_checkpoint/services/location_service.dart';
import 'package:rapidpass_checkpoint/services/pass_validation_service.dart';
import 'package:rapidpass_checkpoint/viewmodel/device_info_model.dart';
import 'package:sqflite/sqflite.dart' show getDatabasesPath;

import 'env.dart' as Env;
import 'models/check_plate_or_control_args.dart';
import 'package:rapidpass_checkpoint/common/constants/rapid_route_constants.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((_) => runApp(RapidPassCheckpointApp()));
}

class RapidPassCheckpointApp extends StatelessWidget {
  // Local
  static const String databaseName = 'rapid_pass.sqlite';
  final LocalDatabaseService _localDatabaseService = LocalDatabaseService(
    appDatabase: AppDatabase(LazyDatabase(() async {
      final dbFolder = await getDatabasesPath();
      final file = File(p.join(dbFolder, 'db.sqlite'));
      return VmDatabase(file);
    })),
  );

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    debugPrint('apiBaseUrl: ${Env.apiBaseUrl}');
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
              baseUrl: Env.apiBaseUrl,
            ),
            localDatabaseService: _localDatabaseService,
          ),
        ),
        ProxyProvider<ApiRepository, PassValidationService>(
          update: (_, apiRepository, __) =>
              PassValidationService(apiRepository),
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
        initialRoute: RapidPassRoutes.WELCOME_SCREEN,
        routes: {RapidPassRoutes.WELCOME_SCREEN: (_) => WelcomeScreen()},

        /// Similar to 404 not found.
        onUnknownRoute: (settings) => CupertinoPageRoute(
          builder: (_) => MainMenuScreen(),
          settings: settings,
        ),
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case RapidPassRoutes.WELCOME_SCREEN:
              return CupertinoPageRoute(
                builder: (_) => MainMenuScreen(),
                settings: settings,
              );
            case RapidPassRoutes.SCAN_RESULT_SCREEN:
              return CupertinoPageRoute(
                builder: (_) => ScanResultScreen(settings.arguments),
                settings: settings,
              );
            case RapidPassRoutes.CHECK_PLATE_OR_CODE_RESULTS:
              return CupertinoPageRoute(
                  builder: (_) =>
                      CheckPlateOrControlCodeResultsScreen(settings.arguments),
                  settings: settings);
            case RapidPassRoutes.CHECK_PLATE_NUMBER:
              return CupertinoPageRoute(
                builder: (_) {
                  return CheckPlateOrControlScreen(
                      CheckPlateOrControlScreenModeType.plate);
                },
              );
            case RapidPassRoutes.CHECK_CONTROL_NUMBER:
              return CupertinoPageRoute(
                builder: (_) {
                  return CheckPlateOrControlScreen(
                      CheckPlateOrControlScreenModeType.control);
                },
              );
            case RapidPassRoutes.SCAN_QR_CODE:
              return CupertinoPageRoute(
                builder: (_) => QrScannerScreen(),
                settings: settings,
              );
            case RapidPassRoutes.VIEW_MORE_INFO:
              return CupertinoPageRoute(
                builder: (_) => ViewMoreInfoScreen(),
                settings: settings,
              );
            case RapidPassRoutes.ABOUT:
              return CupertinoPageRoute(
                builder: (_) => About(),
              );
          }
          return null;
        },
      ),
    );
  }
}
