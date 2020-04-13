import 'package:flutter/widgets.dart';
import 'package:moor/moor.dart';
import 'package:moor_ffi/moor_ffi.dart';
import 'package:rapidpass_checkpoint/data/app_database.dart';
import 'package:rapidpass_checkpoint/models/app_secrets.dart';
import 'package:rapidpass_checkpoint/models/database_sync_state.dart';
import 'package:rapidpass_checkpoint/services/api_service.dart';
import 'package:rapidpass_checkpoint/services/app_storage.dart';
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
    test('test authenticateDevice() happy path', () async {
      final VcrAdapter adapter = VcrAdapter();
      adapter.useCassette('authenticate-device');
      apiService = ApiService(
          httpClientAdapter: adapter,
          baseUrl: 'https://rapidpass-api-stage.azurewebsites.net/api/v1/');
      final AppSecrets appSecrets = await apiService.authenticateDevice(
          imei: '358240051111110',
          masterKey:
              '3D4BA45B2E32DFBCEC318FE76FE1F0AD913A05718F99368AFE8E808146F3D0F488B2D01440FC911273137748BE944A6997BE3BFEEB83999E1E96F4D52FB877A6');
      print(appSecrets.signingKey);
      print(appSecrets.encryptionKey);
      print(appSecrets.accessCode);
      expect(
          appSecrets.signingKey,
          equals(
              'DDBE7467FD2AA46928631B979AECAA492B9058451755DD20B43CD106774EEB9B'));
      expect(
          appSecrets.encryptionKey,
          equals(
              'B17697FF67EB05CA9264F9D2E3D805EBAFE2EF2F06B321B4D940A26EBBF792D8'));
      expect(
          appSecrets.accessCode,
          equals(
              'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIzNTgyNDAwNTExMTExMTAiLCJleHAiOjE1ODYxNTE2NzcsImlhdCI6MTU4NjE1MTY0NywiZ3JvdXAiOiJjaGVja3BvaW50In0.29Tx6FEcRsatKGYuLdzjV5N6zo8y4WqWR3uYEmH3_MM'));
    });

    test('test authenticateDevice() invalid IMEI', () async {
      final VcrAdapter adapter = VcrAdapter();
      adapter.useCassette('authenticate-device-invalid-imei');
      apiService = ApiService(
          httpClientAdapter: adapter,
          baseUrl: 'https://rapidpass-api-stage.azurewebsites.net/api/v1/');
      apiService
          .authenticateDevice(
              imei: '0',
              masterKey:
                  '3D4BA45B2E32DFBCEC318FE76FE1F0AD913A05718F99368AFE8E808146F3D0F488B2D01440FC911273137748BE944A6997BE3BFEEB83999E1E96F4D52FB877A6')
          .catchError(expectAsync1((e) {
        expect(e is ApiException, isTrue);
        expect((e as ApiException).message,
            equals('Device with IMEI 0 is not registered.'));
      }));
    });

    test('test authenticateDevice() invalid master key', () async {
      final VcrAdapter adapter = VcrAdapter();
      adapter.useCassette('authenticate-device-invalid-masterkey');
      apiService = ApiService(
          httpClientAdapter: adapter,
          baseUrl: 'https://rapidpass-api-stage.azurewebsites.net/api/v1/');
      apiService
          .authenticateDevice(imei: '358240051111110', masterKey: 'x')
          .catchError(expectAsync1((e) {
        expect(e is ApiException, isTrue);
        expect((e as ApiException).message, equals('Unauthorized'));
      }));
    });

    test('test getBatchPasses', () async {
      WidgetsFlutterBinding.ensureInitialized();
      final VcrAdapter adapter = VcrAdapter();
      adapter.useCassette('batch/access-passes');
      apiService = ApiService(
          httpClientAdapter: adapter,
          baseUrl: 'https://rapidpass-api-stage.azurewebsites.net/api/v1/');
      final int before = await database.countPasses();
      print('before: $before');
      final String accessToken = '80Y+wph9EAL6NwmZ0iW1psMRHl2B31iSy6NbzByczI4=';
      final DatabaseSyncState state = DatabaseSyncState(lastSyncOn: 0);
      try {
        await apiService.getBatchPasses(accessToken, state);
      } catch (e) {
        print(e);
      }
      print('state: $state');

      final Uint8List encryptionKey = AppStorage.generateRandomEncryptionKey();
      final databaseService = LocalDatabaseService(
          appDatabase: database, encryptionKey: encryptionKey);
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
