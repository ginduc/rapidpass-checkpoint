import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:rapidpass_checkpoint/components/flavor_banner.dart';
import 'package:rapidpass_checkpoint/helpers/dialog_helper.dart';
import 'package:rapidpass_checkpoint/models/app_state.dart';
import 'package:rapidpass_checkpoint/models/database_sync_state.dart';
import 'package:rapidpass_checkpoint/repository/api_repository.dart';
import 'package:rapidpass_checkpoint/services/app_storage.dart';
import 'package:rapidpass_checkpoint/themes/default.dart';

class UpdateDatabaseScreen extends StatefulWidget {
  @override
  _UpdateDatabaseScreenState createState() => _UpdateDatabaseScreenState();
}

class _UpdateDatabaseScreenState extends State<UpdateDatabaseScreen> {
  bool _hasConnection = true;
  bool _isUpdating = false;
  double _progressValue = 0;
  ProgressDialog progressDialog;

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  initState() {
    super.initState();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      bool _tempHasConnection;
      if (result == ConnectivityResult.none) {
        _tempHasConnection = false;
      } else {
        _tempHasConnection = true;
      }

      if (_tempHasConnection != _hasConnection) {
        _hasConnection = _tempHasConnection;
        setState(() {});
      }
    });
  }

  @override
  dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Widget _buildRecordListView() {
    final appState = Provider.of<AppState>(context, listen: false);
    final databaseSyncLog = appState.databaseSyncLog;

    return Expanded(
      child: LayoutBuilder(
        builder: (bContext, constraints) {
          return Container(
            margin: EdgeInsets.symmetric(vertical: 20),
            height: constraints.maxHeight,
            child: databaseSyncLog.isNotEmpty
                ? ListView.builder(
                    itemBuilder: (bContext, index) => Container(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 20),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[200])),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              '${databaseSyncLog[index]['count']} Record${databaseSyncLog[index]['count'] > 1 ? 's' : ''} Added',
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                            Text(
                              '${DateFormat('MMM dd, yyyy hh:mm aaa').format(new DateTime.fromMillisecondsSinceEpoch(databaseSyncLog[index]['dateTime']))}',
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ),
                    itemCount: databaseSyncLog.length,
                  )
                : null,
          );
        },
      ),
    );
  }

  Widget _buildOfflineContent(Size screenSize) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.20),
            child: Text(
              'Please connect your device\n'
              'to an internet connection\n'
              'to Update Database',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[400], fontSize: 16),
            ),
          ),
          Container(
            height: 90,
            child: Center(
              child: Text(
                'OFFLINE',
                style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterContent() {
    final appState = Provider.of<AppState>(context, listen: false);

    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        children: <Widget>[
          SizedBox(
            width: 200,
            child: FlatButton(
              onPressed: _hasConnection
                  ? () {
                      if (_isUpdating) return;
                      _isUpdating = true;
                      _updateDatabase(context);
                      setState(() {});
                    }
                  : null,
              child: Text(_isUpdating ? 'Please Wait...' : 'Sync'),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0),
              ),
              color: green300,
              disabledColor: Colors.grey[400],
              textColor: Colors.white,
              disabledTextColor: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          Container(
            child: Text(
              appState.databaseLastUpdated > 0
                  ? 'UPDATED AS OF\n'
                      '${DateFormat('hh:mm aaa MMMM dd, yyyy').format(DateTime.fromMillisecondsSinceEpoch(appState.databaseLastUpdated))}\n'
                      'Total of ${appState.databaseRecordCount} Records'
                  : 'There are no records in database.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 10),
            ),
          )
        ],
      ),
    );
  }

  Widget _showProgressBar() {
    return Expanded(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: LinearProgressIndicator(
            backgroundColor: deepPurple300,
            valueColor: AlwaysStoppedAnimation<Color>(deepPurple600),
            value: _progressValue,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return FlavorBanner(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Update Database'),
        ),
        body: Column(
          children: <Widget>[
            _buildRecordListView(),
            if (!_hasConnection) _buildOfflineContent(screenSize),
            // if (_isUpdating) _showProgressBar(),
            _buildFooterContent(),
          ],
        ),
      ),
    );
  }

  Future _updateDatabase(final BuildContext context) async {
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

    await progressDialog.show();
    final ApiRepository apiRepository =
        Provider.of<ApiRepository>(context, listen: false);
    final appState = Provider.of<AppState>(context, listen: false);
    final accessCode = appState.appSecrets.accessCode;
    final int lastSyncTimestamp = DateTime.now().millisecondsSinceEpoch;
    String title = "";
    String message = "";

    if (appState.databaseSyncLog.isEmpty) {
      await AppStorage.setLastSyncOn(0).then((timestamp) {
        debugPrint('After setLastSyncOn(), timestamp: $timestamp');
        appState.databaseLastUpdated = timestamp;
      });
    }

    progressDialog.update(progress: 0);
    _progressValue = 0;

    DatabaseSyncState state =
        await apiRepository.batchDownloadAndInsertPasses(accessCode);
    if (state == null) {
      title = 'Database sync error';
      message = 'An unknown error occurred.';
    } else if (state.exception == null) {
      final int totalPages = state.totalPages;
      debugPrint('state.totalPages: $totalPages');
      if (totalPages > 0) {
        while (state.pageNumber < totalPages) {
          final progress = ((state.pageNumber / totalPages) * 10000) ~/ 100;
          progressDialog.update(progress: progress.toDouble());

          setState(() {
            _progressValue = (state.pageNumber / totalPages);
          });
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
      title = 'Database sync error';
      message = state.statusMessage ?? e.toString();
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
    } else {
      int totalRecords = appState.databaseRecordCount;
      await AppStorage.setLastSyncOn(lastSyncTimestamp).then((timestamp) {
        debugPrint('After setLastSyncOn(), timestamp: $timestamp');
        appState.databaseLastUpdated = timestamp;
      });

      if (state.insertedRowsCount > 0) {
        totalRecords = await apiRepository.localDatabaseService.countPasses();
        appState.databaseRecordCount = totalRecords;

        final _record = {
          'count': state.insertedRowsCount,
          'dateTime': lastSyncTimestamp
        };
        await AppStorage.addDatabaseSyncLog(_record)
            .then((_) => appState.addDatabaseSyncLog(_record));
      }

      title = 'Database Updated';
      message = state.insertedRowsCount > 0
          ? 'Downloaded ${state.insertedRowsCount} record(s).'
          : 'No new records found. Total records in database is $totalRecords.';
    }

    await progressDialog.hide().then((_) =>
        DialogHelper.showAlertDialog(context, title: title, message: message));

    setState(() {
      _isUpdating = false;
    });
  }
}
