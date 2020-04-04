import 'dart:developer';

import 'package:moor/moor.dart';
import 'package:moor_ffi/moor_ffi.dart';
import 'package:rapidpass_checkpoint/data/app_database.dart';
import 'package:rapidpass_checkpoint/models/control_code.dart';
import 'package:test/test.dart';

void main() {
  AppDatabase database;

  setUp(() {
    database = AppDatabase(VmDatabase.memory());
  });
  tearDown(() async {
    // noop
  });

  final controlCodeNumber = ControlCode.decode('09TK6VJ2');

  ValidPassesCompanion createValidPassCompanion() {
    return ValidPassesCompanion(
      controlCode: Value(controlCodeNumber),
      passType: Value(0),
      validFrom: Value(1582992000),
      validUntil: Value(1588262400),
      idOrPlate: Value('NAZ2070'),
      company: Value('DCTx'),
      homeAddress: Value('Manila'),
    );
  }

  test('ValidPass.fromJson()', () {
    final json = {
      'apor': 'GR',
      'controlCode': 383069708,
      'idOrPlate': 'N02-10-017975',
      'idType': 'PLT',
      'issuedOn': 1585985763,
      'passType': 1,
      'status': 'APPROVED',
      'validFrom': 1585986285,
      'validUntil': 1586707199
    };
    final validPass = ValidPass.fromJson(json);
    print(inspect(validPass));
  });

  group('AppDatabase test group', () {
    test('insertValidPass works', () async {
      final ValidPassesCompanion validPass = createValidPassCompanion();
      database.insertValidPass(validPass);
    });
    test('streamValidPass works', () async {
      final ValidPassesCompanion validPass = createValidPassCompanion();
      database.insertValidPass(validPass);
      final ValidPass actual =
          await database.streamValidPass(controlCodeNumber).first;
      expect(actual.controlCode, equals(controlCodeNumber));
      expect(actual.passType, equals(0));
      expect(actual.validFrom, equals(1582992000));
      expect(actual.validUntil, equals(1588262400));
    });
  });
}
