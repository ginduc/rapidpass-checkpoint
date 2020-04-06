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
          baseUrl: 'https://rapidpass-api-stage.azurewebsites.net/api/v1/');
      final result = await apiService.authenticateDevice(
          imei: '358240051111110',
          masterKey:
              '3D4BA45B2E32DFBCEC318FE76FE1F0AD913A05718F99368AFE8E808146F3D0F488B2D01440FC911273137748BE944A6997BE3BFEEB83999E1E96F4D52FB877A6');
      print(result['signingKey']);
      print(result['encryptionKey']);
      print(result['accessCode']);
      expect(
          result['signingKey'],
          equals(
              'DDBE7467FD2AA46928631B979AECAA492B9058451755DD20B43CD106774EEB9B'));
      expect(
          result['encryptionKey'],
          equals(
              'B17697FF67EB05CA9264F9D2E3D805EBAFE2EF2F06B321B4D940A26EBBF792D8'));
      expect(
          result['accessCode'],
          equals(
              'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIzNTgyNDAwNTExMTExMTAiLCJleHAiOjE1ODYxNTE2NzcsImlhdCI6MTU4NjE1MTY0NywiZ3JvdXAiOiJjaGVja3BvaW50In0.29Tx6FEcRsatKGYuLdzjV5N6zo8y4WqWR3uYEmH3_MM'));
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
