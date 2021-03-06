import 'dart:async';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:rapidpass_checkpoint/common/constants/rapid_asset_constants.dart';
import 'package:rapidpass_checkpoint/components/flavor_banner.dart';
import 'package:rapidpass_checkpoint/components/rapid_main_menu_button.dart';
import 'package:rapidpass_checkpoint/helpers/dialog_helper.dart';
import 'package:rapidpass_checkpoint/models/app_state.dart';
import 'package:rapidpass_checkpoint/models/database_sync_state.dart';
import 'package:rapidpass_checkpoint/models/scan_results.dart';
import 'package:rapidpass_checkpoint/repository/api_repository.dart';
import 'package:rapidpass_checkpoint/services/app_storage.dart';
import 'package:rapidpass_checkpoint/services/pass_validation_service.dart';

class MainMenuScreen extends StatelessWidget {
  @override
  Widget build(final BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        // However we got here, on 'Back' go back all the way to the Welcome screen
        Navigator.popUntil(context, ModalRoute.withName('/'));
        return Future.value(false);
      },
      child: FlavorBanner(
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
            iconPath: RapidAssetConstants.icPlateNumberGray,
            iconPathInverted: RapidAssetConstants.icPlateNumberWhite,
            borderColor: Colors.grey,
            textColor: Colors.grey,
            onPressed: () => DialogHelper.showAlertDialog(context,
                title: "Temporarily disabled"),
          ),
          RapidMainMenuButton(
            title: 'Control Number',
            iconPath: RapidAssetConstants.icControlCodeGray,
            iconPathInverted: RapidAssetConstants.icControlCodeWhite,
            borderColor: Colors.grey,
            textColor: Colors.grey,
            onPressed: () => DialogHelper.showAlertDialog(context,
                title: "Temporarily disabled"),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: SizedBox(
              height: 48.0,
              width: 300.0,
              child: RaisedButton(
                color: Colors.grey,
                shape: new RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.0)),
                onPressed: () => DialogHelper.showAlertDialog(context,
                    title: "Temporarily disabled"),
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
    final accessCode = appState.appSecrets.accessCode;
    DatabaseSyncState state =
        await apiRepository.batchDownloadAndInsertPasses(accessCode);
    if (state == null) {
      await progressDialog.hide().then((_) => DialogHelper.showAlertDialog(
          context,
          title: 'Database sync error',
          message: 'An unknown error occurred.'));
    }
    if (state.exception == null) {
      final int totalPages = state.totalPages;
      debugPrint('state.totalPages: $totalPages');
      if (totalPages > 0) {
        while (state.pageNumber < totalPages) {
          final progress = ((state.pageNumber / totalPages) * 10000) ~/ 100;
          progressDialog.update(progress: progress.toDouble());
          state = await apiRepository.continueBatchDownloadAndInsertPasses(
              accessCode, state);
          if (state.exception != null) {
            break;
          }
        }
      }
    }
    final e = state.exception;
    if (e != null) {
      String title = 'Database sync error';
      String message = state.statusMessage ?? e.toString();
      if (e is DioError) {
        switch (e.type) {
          case DioErrorType.SEND_TIMEOUT:
            continue timeout;
          case DioErrorType.CONNECT_TIMEOUT:
            continue timeout;
          timeout:
          case DioErrorType.RECEIVE_TIMEOUT:
            title = 'Network error';
            message = 'Please check your network settings and try again.';
            break;
          default:
          // noop
        }
      }
      await progressDialog.hide().then((_) => DialogHelper.showAlertDialog(
          context,
          title: title,
          message: message));
    } else {
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
  }

  Future _scanAndNavigate(final BuildContext context) async {
    final scanResults = await MainMenu.scanAndValidate(context);
    debugPrint('scanAndValidate() returned $scanResults');
    if (scanResults is ScanResults) {
      Navigator.pushNamed(context, '/scanResults', arguments: scanResults);
    }
  }

  static Future<ScanResults> scanAndValidate(final BuildContext context) async {
    // TODO Make this not timing sensitive
    final AppState appState = Provider.of<AppState>(context, listen: false);
    final PassValidationService passValidationService =
        Provider.of<PassValidationService>(context, listen: false);
    try {
      final String base64Encoded = await BarcodeScanner.scan();
      debugPrint('base64Encoded: $base64Encoded');
      if (base64Encoded == null) {
        // 'Back' button pressed on scanner
        return null;
      } else {
        final ScanResults deserializedQrCode =
            PassValidationService.deserializeAndValidate(
                appState.appSecrets, base64Encoded);
        debugPrint('deserializedQrCode.isValid: ${deserializedQrCode.isValid}');
        if (deserializedQrCode.isValid) {
          final ScanResults fromDatabase = await passValidationService
              .checkControlNumber(deserializedQrCode.qrData.controlCode);
          debugPrint('fromDatabase.isValid: ${fromDatabase.isValid}');
          return fromDatabase.isValid ? fromDatabase : deserializedQrCode;
        } else {
          return deserializedQrCode;
        }
      }
    } catch (e) {
      debugPrint('Error occured: $e');
    }
    return null;
  }
}
