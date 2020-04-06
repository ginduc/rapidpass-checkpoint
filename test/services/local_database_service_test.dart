import 'package:moor/moor.dart';
import 'package:moor_ffi/moor_ffi.dart';
import 'package:rapidpass_checkpoint/data/app_database.dart';
import 'package:rapidpass_checkpoint/models/control_code.dart';
import 'package:rapidpass_checkpoint/services/local_database_service.dart';
import 'package:test/test.dart';

void main() {
  AppDatabase database;
  LocalDatabaseService localDatabaseService;

  setUp(() {
    database = AppDatabase(VmDatabase.memory());
    localDatabaseService = LocalDatabaseService(appDatabase: database);
  });
  tearDown(() async {
    localDatabaseService.dispose();
  });

  final controlCodeNumber = ControlCode.decode('09TK6VJ2');

  ValidPassesCompanion createValidPassCompanion() {
    return ValidPassesCompanion(
      controlCode: Value(controlCodeNumber),
      passType: Value(0),
      apor: Value('GO'),
      validFrom: Value(1582992000),
      validUntil: Value(1588262400),
      idType: Value('PLT'),
      idOrPlate: Value('NAZ2070'),
      company: Value('DCTx'),
      homeAddress: Value('Manila'),
    );
  }

  group('LocalDatabaseService test group', () {
    test('streamValidPass works', () async {
      final ValidPassesCompanion validPass = createValidPassCompanion();
      database.insertValidPass(validPass);
      final ValidPass actual = await localDatabaseService
          .getValidPassByStringControlCode('09TK6VJ2');
      expect(actual.controlCode, equals(controlCodeNumber));
      expect(actual.passType, equals(0));
      expect(actual.validFrom, equals(1582992000));
      expect(actual.validUntil, equals(1588262400));
    });
  });
}
