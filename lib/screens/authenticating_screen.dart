import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:rapidpass_checkpoint/helpers/dialog_helper.dart';
import 'package:rapidpass_checkpoint/models/app_secrets.dart';
import 'package:rapidpass_checkpoint/models/app_state.dart';
import 'package:rapidpass_checkpoint/repository/api_repository.dart';
import 'package:rapidpass_checkpoint/services/api_service.dart';
import 'package:rapidpass_checkpoint/themes/default.dart';
import 'package:rapidpass_checkpoint/viewmodel/device_info_model.dart';

class AuthenticatingScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AuthenticatingScreenState();
}

class AuthenticatingScreenState extends State<AuthenticatingScreen> {
  Future<AppSecrets> _futureAppSecrets;

  @override
  void initState() {
    final ApiRepository apiRepository =
        Provider.of<ApiRepository>(context, listen: false);
    final DeviceInfoModel deviceInfoModel =
        Provider.of<DeviceInfoModel>(context, listen: false);
    final AppState appState = Provider.of<AppState>(context, listen: false);
    _futureAppSecrets = _authenticate(apiRepository.apiService,
            deviceInfoModel.imei, appState.masterQrCode)
        .then((appSecrets) {
      appState
          .setAppSecrets(appSecrets)
          .then((_) => Navigator.pushReplacementNamed(context, '/menu'));
      return appSecrets;
    }).catchError((e) {
      debugPrint(e.toString());
      String title = 'Authentication error';
      if (e is ApiException) {
        if (e.statusCode >= 500 && e.statusCode < 600) {
          title = 'Server error';
        }
      }
      DialogHelper.showAlertDialog(context, title: title, message: e.message)
          .then((_) {
        Navigator.popUntil(context, ModalRoute.withName('/'));
      });
    });
    super.initState();
  }

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Connecting to API')),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
              SpinKitWave(
                color: deepPurple600,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0, left: 8.0),
                child: FutureBuilder<AppSecrets>(
                    future: _futureAppSecrets,
                    builder: (_, snapshot) => Text(
                        snapshot.hasData ? 'Logged in' : 'Authenticating...')),
              )
            ])));
  }

  Future<AppSecrets> _authenticate(final ApiService apiService,
      final String imei, final String masterQrCode) async {
    return apiService.authenticateDevice(imei: imei, masterKey: masterQrCode);
  }
}
