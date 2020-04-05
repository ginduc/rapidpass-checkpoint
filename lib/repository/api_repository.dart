import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:rapidpass_checkpoint/data/app_database.dart';
import 'package:rapidpass_checkpoint/models/control_code.dart';
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
    final DatabaseSyncState state = DatabaseSyncState(lastSyncOn: lastSyncOn);
    try {
      await apiService.getBatchPasses(state);
      int inserted = 0;
      state.passesForInsert.forEach((companion) async {
        var controlCodeNumber = companion.controlCode.value;
        debugPrint('Got pass ${ControlCode.encode(controlCodeNumber)}');
        final validPass = await localDatabaseService
            .getValidPassByIntegerControlCode(controlCodeNumber);
        if (validPass == null) {
          debugPrint(
              "Control code ${ControlCode.encode(controlCodeNumber)} not found in local database, inserting...");
          await localDatabaseService.insertValidPass(companion);
        } else {
          debugPrint(
              "Control code ${ControlCode.encode(controlCodeNumber)} already found in local database, skipping...");
        }
        inserted += 1;
      });
      debugPrint('inserted: $inserted');
      state.insertedRowsCount = state.insertedRowsCount + inserted;
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
      final DatabaseSyncState newState = await apiService.getBatchPasses(state);
      int inserted = 0;
      newState.passesForInsert.forEach((companion) async {
        var controlCodeNumber = companion.controlCode.value;
        debugPrint('Got pass ${ControlCode.encode(controlCodeNumber)}');
        final validPass = await localDatabaseService
            .getValidPassByIntegerControlCode(controlCodeNumber);
        if (validPass == null) {
          debugPrint(
              "Control code ${ControlCode.encode(controlCodeNumber)} not found in local database, inserting...");
          await localDatabaseService.insertValidPass(companion);
        } else {
          debugPrint(
              "Control code ${ControlCode.encode(controlCodeNumber)} already found in local database, skipping...");
        }
        inserted += 1;
      });
      debugPrint('inserted: $inserted');
      state.insertedRowsCount = state.insertedRowsCount + inserted;
      debugPrint('state.insertedRowsCount: ${state.insertedRowsCount}');
      final int after = await localDatabaseService.countPasses();
      debugPrint('after: $after');
      return newState;
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
