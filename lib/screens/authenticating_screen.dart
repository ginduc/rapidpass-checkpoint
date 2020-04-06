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
    _futureAppSecrets = _authenticate(
        apiRepository.apiService, deviceInfoModel.imei, appState.masterQrCode);
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
                child: Text('Authenticating...'),
              )
            ])));
  }

  Future<AppSecrets> _authenticate(final ApiService apiService,
      final String imei, final String masterQrCode) async {
    try {
      return apiService.authenticateDevice(imei: imei, masterKey: masterQrCode);
    } on ApiException catch (e) {
      debugPrint(e.toString());
      DialogHelper.showAlertDialog(context,
          title: 'Authentication error', message: e.message);
      throw e;
    }
  }
}
