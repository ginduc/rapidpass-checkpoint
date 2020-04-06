import 'dart:async';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:rapidpass_checkpoint/common/constants/rapid_asset_constants.dart';
import 'package:rapidpass_checkpoint/components/rapid_main_menu_button.dart';
import 'package:rapidpass_checkpoint/helpers/dialog_helper.dart';
import 'package:rapidpass_checkpoint/models/app_state.dart';
import 'package:rapidpass_checkpoint/models/database_sync_state.dart';
import 'package:rapidpass_checkpoint/models/scan_results.dart';
import 'package:rapidpass_checkpoint/repository/api_repository.dart';
import 'package:rapidpass_checkpoint/services/app_storage.dart';
import 'package:rapidpass_checkpoint/services/pass_validation_service.dart';
import 'package:rapidpass_checkpoint/themes/default.dart';

class MainMenuScreen extends StatelessWidget {
  @override
  Widget build(final BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        // However we got here, on 'Back' go back all the way to the Welcome screen
        Navigator.popUntil(context, ModalRoute.withName('/'));
        return Future.value(false);
      },
      child: Scaffold(
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
      ),
    );
  }
}

class MainMenu extends StatelessWidget {
  ProgressDialog progressDialog;
  @override
  Widget build(BuildContext context) {
    progressDialog = ProgressDialog(context, type: ProgressDialogType.Download)
      ..style(
          message: 'Updating Database...',
          borderRadius: 10.0,
          backgroundColor: Colors.white,
          progressWidget: CircularProgressIndicator(),
          elevation: 10.0,
          insetAnimCurve: Curves.easeInOut,
          progress: 0.0,
          maxProgress: 100.0,
          progressTextStyle: TextStyle(
              color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
          messageTextStyle: TextStyle(
              color: Colors.black,
              fontSize: 19.0,
              fontWeight: FontWeight.w600));
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
                 Navigator.pushNamed(context, '/updateDatabase');
                  // _updateDatabase(context);
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
    await progressDialog.show();
    final ApiRepository apiRepository =
        Provider.of<ApiRepository>(context, listen: false);
    final appState = Provider.of<AppState>(context, listen: false);
    DatabaseSyncState state =
        await apiRepository.batchDownloadAndInsertPasses();
    if (state == null) {
      progressDialog.hide().then((_) => DialogHelper.showAlertDialog(context,
          title: 'Database sync error', message: 'An unknown error occurred.'));
    }
    final int totalPages = state.totalPages;
    debugPrint('state.totalPages: $totalPages');
    if (totalPages > 0) {
      while (state.pageNumber < totalPages) {
        state.pageNumber = state.pageNumber + 1;
        progressDialog.update(progress: state.pageNumber / totalPages);
        state = await apiRepository.continueBatchDownloadAndInsertPasses(state);
      }
    }
    final int totalRecords =
        await apiRepository.localDatabaseService.countPasses();
    final String message = state.insertedRowsCount > 0
        ? 'Downloaded ${state.insertedRowsCount} record(s).'
        : 'No new records found. Total records in database is $totalRecords.';
    progressDialog.hide().then((_) async {
      DialogHelper.showAlertDialog(context,
          title: 'Database Updated', message: message);
      await AppStorage.setLastSyncOnToNow().then((timestamp) {
        debugPrint('After setLastSyncOnToNow(), timestamp: $timestamp');
        appState.databaseLastUpdated = timestamp;
      });
    });
  }

  Future _scanAndNavigate(final BuildContext context) async {
    final scanResults = await scanAndValidate(context);
    if (scanResults is ScanResults) {
      Navigator.pushNamed(context, '/scanResults', arguments: scanResults);
    }
  }

  static Future<ScanResults> scanAndValidate(final BuildContext context) async {
    // TODO Make this not timing sensitive
    final AppState appState = Provider.of<AppState>(context, listen: false);
    try {
      final String base64Encoded = await BarcodeScanner.scan();
      debugPrint('base64Encoded: $base64Encoded');
      if (base64Encoded != null) {
        return PassValidationService.deserializeAndValidate(
            appState.appSecrets, base64Encoded);
      }
    } catch (e) {
      debugPrint('Error occured: $e');
    }
    // TODO Display invalid code
    return null;
  }
}
