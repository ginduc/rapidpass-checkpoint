import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rapidpass_checkpoint/components/flavor_banner.dart';
import 'package:rapidpass_checkpoint/components/rounded_button.dart';
import 'package:rapidpass_checkpoint/models/app_state.dart';
import 'package:rapidpass_checkpoint/repository/api_repository.dart';
import 'package:rapidpass_checkpoint/screens/authenticating_screen.dart';
import 'package:rapidpass_checkpoint/services/app_storage.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SettingsScreenState();
  }
}

class SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);

    return FlavorBanner(
      child: Scaffold(
          appBar: AppBar(title: Text('Settings')),
          body: Center(
              child: SingleChildScrollView(
                  child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Advanced Settings',
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
              ),
              InkWell(
                child: RoundedButton(
                  minWidth: 300.0,
                  text: 'Reauthenticate Device',
                  onPressed: () => _reauthenticateDevice(context),
                ),
              ),
              Text(
                  'Number of records in database: ${appState.databaseRecordCount}')
            ],
          )))),
    );
  }

  void _reauthenticateDevice(final BuildContext context) {
    final AppState appState = Provider.of<AppState>(context, listen: false);
    debugPrint('_startButtonPressed()');
    Navigator.pushNamed(context, '/scanQr').then((code) async {
      debugPrint("scanQr returned $code");
      if (code != null) {
        await AppStorage.setMasterQrCode(code).then((_) async {
          appState.masterQrCode = code;
          final result = await Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (_) => AuthenticatingScreen(
                      onSuccess: (c) =>
                          Navigator.popUntil(c, ModalRoute.withName('/')),
                      onError: (c) => Navigator.of(c).pop())));
          debugPrint('result: ${inspect(result)}');
        });
      }
    });
  }
}
