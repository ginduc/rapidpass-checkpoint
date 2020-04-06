import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:rapidpass_checkpoint/data/app_database.dart';
import 'package:rapidpass_checkpoint/models/database_sync_state.dart';
import 'package:rapidpass_checkpoint/services/api_service.dart';
import 'package:rapidpass_checkpoint/services/local_database_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

// TODO Rename this to RapidPassRepository
abstract class IApiRepository {
  Future<DatabaseSyncState> batchDownloadAndInsertPasses();
  Future<DatabaseSyncState> continueBatchDownloadAndInsertPasses(
      final DatabaseSyncState state);
  Future<void> verifyPlateNumber(String plateNumber);
  Future<void> verifyControlNumber(int controlNumber);
}

class ApiRepository extends IApiRepository {
  final ApiService apiService;
  final LocalDatabaseService localDatabaseService;

  ApiRepository({
    @required this.apiService,
    @required this.localDatabaseService,
  });

  @override
  Future<DatabaseSyncState> batchDownloadAndInsertPasses() async {
    final int before = await localDatabaseService.countPasses();
    debugPrint('before: $before');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int lastSyncOn =
        prefs.containsKey('lastSyncOn') ? prefs.getInt('lastSyncOn') : 0;
    debugPrint('lastSyncOn: $lastSyncOn');
    final lastSyncOnDateTime =
        DateTime.fromMillisecondsSinceEpoch(lastSyncOn * 1000);
    final DateFormat dateFormat = new DateFormat.yMd().add_jm();
    debugPrint('lastSyncOnDateTime: ${dateFormat.format(lastSyncOnDateTime)}');
    final DatabaseSyncState state = DatabaseSyncState(lastSyncOn: 0);
    try {
      await apiService.getBatchPasses(state);
      localDatabaseService.bulkInsertOrUpdate(state.passesForInsert);
      state.insertedRowsCount =
          state.insertedRowsCount + state.passesForInsert.length;
      debugPrint('state.insertedRowsCount: ${state.insertedRowsCount}');
      final int after = await localDatabaseService.countPasses();
      debugPrint('after: $after');
    } catch (e) {
      debugPrint(e.toString());
      state.exception = e;
      state.statusMessage = e.toString();
    }
    return state;
  }

  @override
  Future<DatabaseSyncState> continueBatchDownloadAndInsertPasses(
      DatabaseSyncState state) async {
    // TODO Factor out common code with above
    final int before = await localDatabaseService.countPasses();
    debugPrint('before: $before');
    debugPrint('state.lastSyncOn: ${state.lastSyncOn}');
    try {
      await apiService.getBatchPasses(state);
      localDatabaseService.bulkInsertOrUpdate(state.passesForInsert);
      state.insertedRowsCount =
          state.insertedRowsCount + state.passesForInsert.length;
      debugPrint('state.insertedRowsCount: ${state.insertedRowsCount}');
      final int after = await localDatabaseService.countPasses();
      debugPrint('after: $after');
      return state;
    } catch (e) {
      debugPrint(e);
    }
  }

  @override
  Future<ValidPass> verifyControlNumber(int controlCodeNumber) async {
    return localDatabaseService
        .getValidPassByIntegerControlCode(controlCodeNumber);
  }

  @override
  Future<void> verifyPlateNumber(String plateNumber) {
    // TODO: implement verifyPlateNumber
    return apiService.verifyPlateNumber(plateNumber);
  }
}
