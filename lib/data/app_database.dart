import 'package:moor/moor.dart';

part 'app_database.g.dart';

@DataClassName('ValidPass')
class ValidPasses extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get passType => integer()();

  TextColumn get apor => text()();

  IntColumn get controlCode => integer().customConstraint('UNIQUE')();

  IntColumn get validFrom => integer()();

  IntColumn get validUntil => integer()();

  TextColumn get idType => text()();

  TextColumn get idOrPlate => text()();

  TextColumn get company => text().nullable()();

  TextColumn get homeAddress => text().nullable()();
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

  Future insertValidPass(final ValidPassesCompanion validPassesCompanion) =>
      into(validPasses).insert(validPassesCompanion);

  Future insertAll(final List<ValidPassesCompanion> forInsertion) {
    return transaction(() {
      List<Future> futures = List();
      for (final vpc in forInsertion) {
        futures.add(insertValidPass(vpc));
      }
      return Future.wait(futures);
    });
  }
}
