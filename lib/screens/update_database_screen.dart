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
  AppState appState;

  bool _hasConnection = true;
  bool _isUpdating = false;
  bool _hasError = false;
  double progress;

  Map<String, Object> _latestUpdateInfo = {
    'count': 200,
    'dateTime': DateTime(0), // ! Assumes there is no database record yet if DateTime is 0
    //DateTime.now(), //DateTime(0), // ! Assumes there is a previous update record
  };

  // Future _updateDatabase() {
  //   await progressDialog.show();
  //   final ApiRepository apiRepository =
  //       Provider.of<ApiRepository>(context, listen: false);
  //   final appState = Provider.of<AppState>(context, listen: false);
  //   DatabaseSyncState state =
  //       await apiRepository.batchDownloadAndInsertPasses();
  //   if (state == null) {
  //     progressDialog.hide().then((_) => DialogHelper.showAlertDialog(context,
  //         title: 'Database sync error', message: 'An unknown error occurred.'));
  //   }
  //   final int totalPages = state.totalPages;
  //   debugPrint('state.totalPages: $totalPages');
  //   if (totalPages > 0) {
  //     while (state.pageNumber < totalPages) {
  //       state.pageNumber = state.pageNumber + 1;
  //       progressDialog.update(progress: state.pageNumber / totalPages);
  //       state = await apiRepository.continueBatchDownloadAndInsertPasses(state);
  //     }
  //   }
  //   final int totalRecords =
  //       await apiRepository.localDatabaseService.countPasses();
  //   final String message = state.insertedRowsCount > 0
  //       ? 'Downloaded ${state.insertedRowsCount} record(s).'
  //       : 'No new records found. Total records in database is $totalRecords.';
  //   progressDialog.hide().then((_) async {
  //     DialogHelper.showAlertDialog(context,
  //         title: 'Database Updated', message: message);
  //     await AppStorage.setLastSyncOnToNow().then((timestamp) {
  //       debugPrint('After setLastSyncOnToNow(), timestamp: $timestamp');
  //       appState.databaseLastUpdated = timestamp;
  //     });
  //   });
  // }

  void _updateDatabase() {
    /* Sync */
    setState(() {
      _isUpdating = !_isUpdating;
    });

    Future.delayed(Duration(seconds: 2), () => 0.1).then((p) {
      setState(() {
        progress = p;
      });
      return Future.delayed(Duration(seconds: 1), () => 0.2);
    }).then((p) {
      setState(() {
        progress += p;
      });
      return Future.delayed(Duration(seconds: 1), () => 0.3);
    }).then((p) {
      setState(() {
        progress += p;
      });
      return Future.delayed(Duration(seconds: 2), () => 0.3);
    }).then((p) {
      setState(() {
        progress += p;
      });
    }).whenComplete(() {
      setState(() {
        progress = null;
        _isUpdating = false;
        _hasError = false;

        // _dummyRecord = [];
        _latestUpdateInfo['dateTime'] = DateTime.now();

        // _dummyRecord = [
        //   {'count': 2000, 'dateTime': DateTime.parse("2020-04-02 16:40:00")},
        //   {'count': 500, 'dateTime': DateTime.parse("2020-03-29 16:00:00")},
        //   {'count': 100, 'dateTime': DateTime.parse("2020-03-28 16:00:00")},
        //   {'count': 2000, 'dateTime': DateTime.parse("2020-04-02 16:40:00")},
        //   {'count': 500, 'dateTime': DateTime.parse("2020-03-29 16:00:00")},
        //   {'count': 100, 'dateTime': DateTime.parse("2020-03-28 16:00:00")},
        //   {'count': 2000, 'dateTime': DateTime.parse("2020-04-02 16:40:00")},
        //   {'count': 500, 'dateTime': DateTime.parse("2020-03-29 16:00:00")},
        //   {'count': 1, 'dateTime': DateTime.parse("2020-03-28 16:00:00")},
        // ];

        if (_hasError) {
          DialogHelper.showAlertDialog(
            context,
            title: 'Error',
            message:
                'There\'s something wrong while getting the new information from the database.',
          );
        } else if (!_hasError) {
          _latestUpdateInfo['count'] = 100;
          final int latestAddedCount = _latestUpdateInfo['count'];
          final String message = latestAddedCount > 0
              ? 'Downloaded $latestAddedCount new ${(latestAddedCount > 1 ? 'records' : 'record')}.'
              : 'No new records found. Total records in database is 500';

          DialogHelper.showAlertDialog(
            context,
            title: 'Database Synced!',
            message: message,
          );
        }
      });
    });
  }

  Widget _buildRecordListView() {
    return Expanded(
      flex: 3,
      child: LayoutBuilder(
        builder: (bContext, constraints) {
          return Container(
            height: constraints.maxHeight,
            width: constraints.maxWidth,
            child: _dummyRecord.isNotEmpty
                ? ListView.separated(
                    separatorBuilder: (context, count) {
                      return const Divider(
                        height: 10,
                        color: Colors.grey,
                      );
                    },
                    itemBuilder: (bContext, index) => Container(
                      child: ListTile(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                        title: Text(
                          '${_dummyRecord[index]['count']} ${(_dummyRecord[index]['count'] as int > 1 ? 'records' : 'record')} Added',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        trailing: Text(
                          '${DateFormat('MM-dd-yyyy').format(_dummyRecord[index]['dateTime'])} ${DateFormat.jm().format(_dummyRecord[index]['dateTime'])}',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                        onTap: () {},
                      ),
                    ),
                    itemCount: _dummyRecord.length,
                  )
                : Container(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.assignment,
                            size: constraints.maxHeight * 0.50,
                            color: Colors.grey),
                        Text(
                          'Log is Empty.',
                          style: Theme.of(context).textTheme.display1.apply(
                                color: Colors.grey,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const Padding(padding: EdgeInsets.only(bottom: 10)),
                        Text(
                          'Press the "Sync" button and start fetching the new updates.',
                          style: TextStyle(
                              fontSize: 20.0, color: Colors.grey[700]),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
          );
        },
      ),
    );
  }

  Widget _buildOfflineContent(Size screenSize) {
    return Expanded(
        child: Container(
      padding: EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.cloud_off, size: 200, color: Colors.grey),
          Text(
            'You are offline.',
            style: Theme.of(context).textTheme.display1.apply(
                  color: Colors.grey,
                ),
            textAlign: TextAlign.center,
          ),
          const Padding(padding: EdgeInsets.only(bottom: 10)),
          Text(
            'Please check your internet connection and try again.',
            style: TextStyle(fontSize: 20.0, color: Colors.grey[700]),
            textAlign: TextAlign.center,
          )
        ],
      ),
    ));
  }

  Widget _buildUpdateErrorMessage() {
    return Expanded(
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.warning, color: Colors.red),
            SizedBox(width: 10),
            Text(
              'Error Updating Database.',
              style: TextStyle(
                color: Colors.red,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooterContent() {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[
          SizedBox(
            width: 250,
            child: FlatButton(
              onPressed:
                  _hasConnection ? !_isUpdating ? _updateDatabase : null : null,
              child: Text(_isUpdating ? 'Please Wait...' : 'Sync',
                  style: TextStyle(fontSize: 16.0)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              color: green300,
              disabledColor: _isUpdating ? Colors.green[200] : Colors.grey[400],
              textColor: Colors.white,
              disabledTextColor: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          Container(
            child: (_latestUpdateInfo['dateTime'] != null &&
                    _latestUpdateInfo['dateTime'] != DateTime(0))
                ? Text(
                    'UPDATED AS OF\n'
                    '${DateFormat.jm().format(_latestUpdateInfo['dateTime'])} ${DateFormat('MMMM dd, yyyy').format(_latestUpdateInfo['dateTime'])}\n'
                    'Total of ${_latestUpdateInfo['count']} ${_latestUpdateInfo['count'] as int > 1 ? 'records' : 'record'}',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 10),
                  )
                : SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
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
            valueColor: AlwaysStoppedAnimation<Color>(deepPurple900),
            value: progress == null ? null : progress,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //   appState = Provider.of<AppState>(context, listen: false);

    // setState(() {
    //   _latestUpdateInfo['dateTime'] = appState.databaseLastUpdatedDateTime;
    // });

    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Update Database'),
      ),
      body: Column(
        children: <Widget>[
          // if (!_isUpdating) _buildRecordListView(),
          // if (!_hasConnection) _buildOfflineContent(screenSize),
          // if (_hasError && _hasConnection && !_isUpdating)
          //   _builUpdateErrorMessage(),
          // if (_isUpdating) _showProgressBar(),
          !_hasConnection
              ? _buildOfflineContent(screenSize)
              : _isUpdating ? _showProgressBar() : _buildRecordListView(),
          if (_hasError && !_isUpdating)
            _buildUpdateErrorMessage(),
          _buildFooterContent(),
        ],
      ),
    );
  }

  // Future _updateDatabase(final BuildContext context) async {
  //   final ApiRepository apiRepository =
  //       Provider.of<ApiRepository>(context, listen: false);
  //   DatabaseSyncState state =
  //       await apiRepository.batchDownloadAndInsertPasses();

  //   // For Functionality Test
  //   // [Uncomment statement below to drive an update failure state]
  //   // state = null;
  //   if (state == null) {
  //     DialogHelper.showAlertDialog(
  //       context,
  //       title: 'Database sync error',
  //       message: 'An unknown error occurred.',
  //     );

  //     setState(() {
  //       _isUpdating = false;
  //       _hasError = true;
  //     });

  //     return;
  //   }

  //   final int totalPages = state.totalPages;
  //   debugPrint('state.totalPages: $totalPages');
  //   if (totalPages > 0) {
  //     while (state.pageNumber < totalPages) {
  //       state.pageNumber = state.pageNumber + 1;
  //       state = await apiRepository.continueBatchDownloadAndInsertPasses(state);
  //     }
  //   }

  //   final int totalRecords =
  //       await apiRepository.localDatabaseService.countPasses();
  //   final String message = state.insertedRowsCount > 0
  //       ? 'Downloaded ${state.insertedRowsCount} ${(state.insertedRowsCount > 1 ? 'records' : 'record')}'
  //       : 'No new records found. Total records in database is $totalRecords';

  //   if (state != null) {
  //     DialogHelper.showAlertDialog(
  //       context,
  //       title: 'Database Updated',
  //       message: message,
  //     );

  //     setState(() {
  //       _hasError = false;
  //       _isUpdating = false;
  //       _latestUpdateInfo['count'] = state.insertedRowsCount;
  //       _latestUpdateInfo['dateTime'] = appState.databaseLastUpdatedDateTime;
  //     });

  //     await AppStorage.setLastSyncOnToNow().then((timestamp) {
  //       debugPrint('After setLastSyncOnToNow(), timestamp: $timestamp');
  //       appState.databaseLastUpdated = timestamp;
  //     });
  //   }
  // }
}

List<Map<String, dynamic>> _dummyRecord = [
  // {'count': 2000, 'dateTime': DateTime.parse("2020-04-02 16:40:00")},
  // {'count': 500, 'dateTime': DateTime.parse("2020-03-29 16:00:00")},
  // {'count': 100, 'dateTime': DateTime.parse("2020-03-28 16:00:00")},
  // {'count': 2000, 'dateTime': DateTime.parse("2020-04-02 16:40:00")},
  // {'count': 500, 'dateTime': DateTime.parse("2020-03-29 16:00:00")},
  // {'count': 100, 'dateTime': DateTime.parse("2020-03-28 16:00:00")},
  // {'count': 2000, 'dateTime': DateTime.parse("2020-04-02 16:40:00")},
  // {'count': 500, 'dateTime': DateTime.parse("2020-03-29 16:00:00")},
  // {'count': 1, 'dateTime': DateTime.parse("2020-03-28 16:00:00")},
];
