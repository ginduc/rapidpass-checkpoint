import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
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

  Map<String, Object> _latestUpdateInfo = {
    'count': 4000,
    'dateTime': DateTime.parse("2020-04-03 16:40:00")
  };

  Widget _buildRecordListView() {
    return Expanded(
      child: LayoutBuilder(
        builder: (bContext, constraints) {
          return Container(
            margin: EdgeInsets.symmetric(vertical: 20),
            height: constraints.maxHeight,
            child: _dummyRecord.isNotEmpty
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
                              '${_dummyRecord[index]['count']} Records Added',
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                            Text(
                              '${DateFormat('MM dd, yyyy').format(_dummyRecord[index]['dateTime'])} ${DateFormat.jm().format(_dummyRecord[index]['dateTime'])}',
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ),
                    itemCount: _dummyRecord.length,
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
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        children: <Widget>[
          SizedBox(
            width: 200,
            child: FlatButton(
              onPressed: _hasConnection
                  ? () {
                      setState(() {
                        _isUpdating = true;
                        _updateDatabase(context);
                      });
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
              'UPDATED AS OF\n'
              '${DateFormat.jm().format(_latestUpdateInfo['dateTime'])} ${DateFormat('MMMM dd, yyyy').format(_latestUpdateInfo['dateTime'])}\n'
              'Total of ${_latestUpdateInfo['count']} Records',
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
            value: 0.5,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Update Database'),
      ),
      body: Column(
        children: <Widget>[
          if (!_isUpdating) _buildRecordListView(),
          if (!_hasConnection) _buildOfflineContent(screenSize),
          if (_isUpdating) _showProgressBar(),
          _buildFooterContent(),
        ],
      ),
    );
  }

  Future _updateDatabase(final BuildContext context) async {
    final ApiRepository apiRepository =
        Provider.of<ApiRepository>(context, listen: false);
    final appState = Provider.of<AppState>(context, listen: false);
    DatabaseSyncState state =
        await apiRepository.batchDownloadAndInsertPasses();
    if (state == null) {
      DialogHelper.showAlertDialog(context,
          title: 'Database sync error', message: 'An unknown error occurred.');
    }
    final int totalPages = state.totalPages;
    debugPrint('state.totalPages: $totalPages');
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
        : 'No new records found. Total records in database is $totalRecords';
    DialogHelper.showAlertDialog(
      context,
      title: 'Database Updated',
      message: message,
      onConfirm: () {
        setState(() {
          _isUpdating = false;
        });
      },
    );
    await AppStorage.setLastSyncOnToNow().then((timestamp) {
      debugPrint('After setLastSyncOnToNow(), timestamp: $timestamp');
      appState.setDatabaseLastUpdated(timestamp);
    });
  }
}

final _dummyRecord = [
  {'count': 2000, 'dateTime': DateTime.parse("2020-04-02 16:40:00")},
  {'count': 500, 'dateTime': DateTime.parse("2020-03-29 16:00:00")},
  {'count': 100, 'dateTime': DateTime.parse("2020-03-28 16:00:00")},
  // {'count': 2000, 'dateTime': DateTime.parse("2020-04-02 16:40:00")},
  // {'count': 500, 'dateTime': DateTime.parse("2020-03-29 16:00:00")},
  // {'count': 100, 'dateTime': DateTime.parse("2020-03-28 16:00:00")},
  // {'count': 2000, 'dateTime': DateTime.parse("2020-04-02 16:40:00")},
  // {'count': 500, 'dateTime': DateTime.parse("2020-03-29 16:00:00")},
  // {'count': 100, 'dateTime': DateTime.parse("2020-03-28 16:00:00")},
];
