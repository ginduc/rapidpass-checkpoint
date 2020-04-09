import 'package:flutter/foundation.dart';
import 'package:moor/moor.dart';

part 'app_database.g.dart';

/// Remember to generate the code using
/// ```
/// flutter packages pub run build_runner build
/// ```
/// Or
/// ```
/// flutter packages pub run build_runner watch
/// ```
@DataClassName('ValidPass')
class ValidPasses extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get passType => integer()();

  TextColumn get apor => text().nullable()();

  IntColumn get controlCode => integer().customConstraint('UNIQUE')();

  IntColumn get validFrom => integer().nullable()();

  IntColumn get validUntil => integer().nullable()();

  TextColumn get idType => text().nullable()();

  TextColumn get idOrPlate => text().nullable()();

  TextColumn get company => text().nullable()();

  TextColumn get homeAddress => text().nullable()();

  TextColumn get status => text()();
}

@DataClassName('InvalidPass')
class InvalidPasses extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get controlCode => integer()();

  TextColumn get status => text()();
}

@UseMoor(tables: [ValidPasses, InvalidPasses])
class AppDatabase extends _$AppDatabase {
  AppDatabase(QueryExecutor executor) : super(executor);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) {
        return m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // TODO: Add implementation here when upgrading the db while on prod
      },
    );
  }

  Future<int> countPasses() async {
    var list = (await select(validPasses).get());
    return list.length;
  }

  Future<ValidPass> getValidPass(final int controlCode) async {
    return await (select(validPasses)
          ..where((u) => u.controlCode.equals(controlCode)))
        .getSingle();
  }

  Future<ValidPass> getValidPassByIdOrPlate(final String idOrPlate) async {
    return await (select(validPasses)
          ..where((u) => u.idOrPlate.equals(idOrPlate)))
        .getSingle();
  }

  Future updateValidPass(final ValidPassesCompanion validPassesCompanion) =>
      update(validPasses).replace(validPassesCompanion);

  Future insertValidPass(final ValidPassesCompanion validPassesCompanion) =>
      into(validPasses).insert(validPassesCompanion);

  Future insertOrUpdateAll(
      final List<ValidPassesCompanion> bulkInsertOrUpdate) {
    return transaction(() {
      List<Future> futures = List();
      for (final vpc in bulkInsertOrUpdate) {
        if (vpc.id != null &&
            vpc.id != Value.absent() &&
            vpc.id.value != null) {
          debugPrint('Updating pass id ${vpc.id.value}');
          futures.add(updateValidPass(vpc));
        } else {
          debugPrint('Inserting pass ${vpc.controlCode.value}');
          futures.add(insertValidPass(vpc));
        }
      }
      return Future.wait(futures);
    });
  }
}
