import 'dart:developer';

import 'package:meta/meta.dart';
import 'package:moor/moor.dart';
import 'package:rapidpass_checkpoint/data/app_database.dart';
import 'package:rapidpass_checkpoint/models/control_code.dart';

abstract class ILocalDatabaseService {
  Future<int> countPasses();
  Future<ValidPass> getValidPassByStringControlCode(final String controlCode);
  Future<ValidPass> getValidPassByIntegerControlCode(final int controlNumber);
  Future<int> insertValidPass(final ValidPassesCompanion companion);
  Future bulkInsert(final List<ValidPassesCompanion> forInserting);
  void dispose();
}

// TODO: Additional logic while retrieving the data from local db should be placed here
class LocalDatabaseService implements ILocalDatabaseService {
  final AppDatabase appDatabase;

  LocalDatabaseService({@required this.appDatabase});

  @override
  Future<ValidPass> getValidPassByStringControlCode(final String controlCode) {
    return getValidPassByIntegerControlCode(ControlCode.decode(controlCode));
  }

  @override
  Future<ValidPass> getValidPassByIntegerControlCode(
      final int controlCodeAsInt) {
    return appDatabase.getValidPass(controlCodeAsInt);
  }

  // Close and clear all expensive resources needed as this class gets killed.
  @override
  void dispose() async {
    await appDatabase.close();
  }

  @override
  Future<int> insertValidPass(final ValidPassesCompanion companion) async {
    return appDatabase.insertValidPass(companion);
  }

  @override
  Future<int> countPasses() async {
    return appDatabase.countPasses();
  }

  @override
  Future bulkInsert(final List<ValidPassesCompanion> forInserting) async {
    final List<ValidPassesCompanion> noExisting = List();
    await appDatabase.batch((batch) {
      print('x: ${inspect(batch)} (${batch.runtimeType})');
      for (final fi in forInserting) {
        getValidPassByIntegerControlCode(fi.controlCode.value).then((existing) {
          print('existing: $existing');
          if (existing == null) {
            noExisting.add(fi);
          }
        });
      }
    });
    print('bulkInsert.noExisting: $noExisting (${noExisting.length})');
    return await appDatabase.insertAll(noExisting);
  }
}
