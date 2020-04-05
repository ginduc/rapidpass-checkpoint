import 'dart:async';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rapidpass_checkpoint/common/constants/rapid_asset_constants.dart';
import 'package:rapidpass_checkpoint/components/rapid_main_menu_button.dart';
import 'package:rapidpass_checkpoint/helpers/dialog_helper.dart';
import 'package:rapidpass_checkpoint/models/database_sync_state.dart';
import 'package:rapidpass_checkpoint/models/scan_results.dart';
import 'package:rapidpass_checkpoint/repository/api_respository.dart';
import 'package:rapidpass_checkpoint/services/pass_validation_service.dart';
import 'package:rapidpass_checkpoint/themes/default.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainMenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('RapidPass Checkpoint')),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              MainMenu(),
            ],
          ),
        ),
      ),
    );
  }
}

class CheckPointWidget extends StatelessWidget {
  final String checkPointName;

  CheckPointWidget(this.checkPointName);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'RapidPass Checkpoint:',
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: deepPurple600),
            ),
          ),
          Container(
            width: 320.0,
            height: 50.0,
            decoration: BoxDecoration(color: deepPurple600),
            child: Center(
              child: Text(
                this.checkPointName,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MainMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            "CHECK VIA:",
            style: Theme.of(context)
                .textTheme
                .body1
                .copyWith(fontWeight: FontWeight.bold),
          ),
          RapidMainMenuButton(
            title: 'Scan QR Code',
            iconPath: RapidAssetConstants.icQrCode,
            iconPathInverted: RapidAssetConstants.icQrCodeWhite,
            onPressed: () => _scanAndNavigate(context),
          ),
          RapidMainMenuButton(
            title: 'Plate Number',
            iconPath: RapidAssetConstants.icPlateNumber,
            iconPathInverted: RapidAssetConstants.icPlateNumberWhite,
            onPressed: () {
              Navigator.pushNamed(context, "/checkPlateNumber");
            },
          ),
          RapidMainMenuButton(
            title: 'Control Number',
            iconPath: RapidAssetConstants.icControlCode,
            iconPathInverted: RapidAssetConstants.icControlCodeWhite,
            onPressed: () {
              Navigator.pushNamed(context, '/checkControlNumber');
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: SizedBox(
              height: 48.0,
              width: 300.0,
              child: RaisedButton(
                color: green300,
                shape: new RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.0)),
                onPressed: () {
                  debugPrint('Update Database pressed');
                  _updateDatabase(context);
                },
                child: Text('Update Database',
                    style: TextStyle(
                        // Not sure how to get rid of color: Colors.white here
                        color: Colors.white,
                        fontSize: 18.0)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future _updateDatabase(final BuildContext context) async {
    final ApiRepository apiRepository =
        Provider.of<ApiRepository>(context, listen: false);
    DatabaseSyncState state =
        await apiRepository.batchDownloadAndInsertPasses();
    if (state == null) {
      DialogHelper.showAlertDialog(context,
          title: 'Database sync error', message: 'An unknown error occurred.');
    }
    final int totalPages = state.totalPages;
    debugPrint('state.totalPages: ${totalPages}');
    if (totalPages > 0) {
      while (state.pageNumber < totalPages) {
        state.pageNumber = state.pageNumber + 1;
        state = await apiRepository.continueBatchDownloadAndInsertPasses(state);
      }
    }
    final int totalRecords =
        await apiRepository.localDatabaseService.countPasses();
    final String message = state.insertedRowsCount > 0
        ? 'Downloaded ${state.insertedRowsCount} records'
        : 'No new records found. Total records in database is ${totalRecords}';
    DialogHelper.showAlertDialog(context,
        title: 'Database Updated', message: message);
    final DateTime now = DateTime.now();
    final int newLastSyncOn = now.millisecondsSinceEpoch ~/ 1000;
    debugPrint('newLastSyncOn: $newLastSyncOn');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('lastSyncOn', newLastSyncOn);
  }

  Future _scanAndNavigate(final BuildContext context) async {
    final scanResults = await scanAndValidate(context);
    if (scanResults is ScanResults) {
      Navigator.pushNamed(context, '/scanResults', arguments: scanResults);
    }
  }

  static Future<ScanResults> scanAndValidate(final BuildContext context) async {
    try {
      final String base64Encoded = await BarcodeScanner.scan();
      debugPrint('base64Encoded: $base64Encoded');
      if (base64Encoded != null) {
        return PassValidationService.deserializeAndValidate(base64Encoded);
      }
    } catch (e) {
      debugPrint('Error occured: $e');
    }
    // TODO Display invalid code
    return null;
  }
}
