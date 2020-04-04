import 'package:moor/moor.dart';

part 'app_database.g.dart';

@DataClassName('ValidPass')
class ValidPasses extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get passType => integer()();

  IntColumn get controlCode => integer()();

  IntColumn get validFrom => integer()();

  IntColumn get validUntil => integer()();

  TextColumn get idOrPlate => text()();

  TextColumn get company => text()();

  TextColumn get homeAddress => text()();
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

  Stream<ValidPass> streamValidPass(final int controlCode) {
    return (select(validPasses)
          ..where((u) => u.controlCode.equals(controlCode)))
        .watchSingle();
  }

  Future insertValidPass(final ValidPassesCompanion validPassesCompanion) =>
      into(validPasses).insert(validPassesCompanion);
}
