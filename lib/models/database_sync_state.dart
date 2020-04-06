import 'package:flutter/foundation.dart';
import 'package:rapidpass_checkpoint/data/app_database.dart';

class DatabaseSyncState {
  final int lastSyncOn;
  final int pageSize;
  int totalPages = 0;
  int totalRows = 0;
  int pageNumber = 0;
  int insertedRowsCount = 0;
  String statusMessage;
  Exception exception;
  List<ValidPassesCompanion> passesForInsert = List();
  DatabaseSyncState({@required this.lastSyncOn, this.pageSize = 100});

  @override
  String toString() {
    return 'DatabaseSyncState(lastSyncOn: $lastSyncOn, '
        'pageSize: $pageSize, '
        'totalPages: $totalPages, '
        'totalRows: $totalRows, '
        'pageNumber: $pageNumber, '
        'insertedRowsCount: $insertedRowsCount)';
  }
}
