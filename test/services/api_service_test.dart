import 'package:moor_ffi/moor_ffi.dart';
import 'package:rapidpass_checkpoint/data/app_database.dart';
import 'package:rapidpass_checkpoint/models/database_sync_state.dart';
import 'package:rapidpass_checkpoint/services/api_service.dart';
import 'package:rapidpass_checkpoint/services/local_database_service.dart';
import 'package:test/test.dart';
import 'package:vcr/vcr.dart';

void main() {
  ApiService apiService;

  AppDatabase database;

  setUp(() {
    database = AppDatabase(VmDatabase.memory(logStatements: false));
  });
  tearDown(() async {
    // noop
  });

  group('ApiService test group', () {
    test('test authenticateDevice()', () async {
      final VcrAdapter adapter = VcrAdapter();
      adapter.useCassette('authenticate-device');
      apiService = ApiService(
          httpClientAdapter: adapter,
          baseUrl: 'https://rapidpass-api.azurewebsites.net/api/v1/');
      final result = await apiService.authenticateDevice(
          imei: '358240051111110', masterKey: '5Mg7JGHTRgpqP7jH');
      print(result);
    });
    test('test getBatchPasses', () async {
      final VcrAdapter adapter = VcrAdapter();
      adapter.useCassette('batch/access-passes');
      apiService = ApiService(
          httpClientAdapter: adapter,
          baseUrl: 'https://rapidpass-api-stage.azurewebsites.net/api/v1/');
      final int before = await database.countPasses();
      print('before: $before');
      DatabaseSyncState state = DatabaseSyncState(lastSyncOn: 0);
      try {
        await apiService.getBatchPasses(state);
      } catch (e) {
        print(e);
      }
      print('state: $state');

      final databaseService = LocalDatabaseService(appDatabase: database);
      final noExisting = await databaseService
          .bulkInsertOrUpdate(state.passesForInsert)
          .then((v) {
        database.countPasses().then((after) {
          print('after: $after');
          expect(after, equals(4));
        });
        return v;
      });
      print('noExisting: $noExisting');
    });
  });
}
