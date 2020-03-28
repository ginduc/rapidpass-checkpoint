import 'package:moor/moor.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'app_database.g.dart';

@DataClassName('QrCode')
class QrCodes extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get controlCode => integer()();

  IntColumn get validFrom => integer()();

  IntColumn get validUntil => integer()();

  BoolColumn get idOrPlate => boolean()();

  TextColumn get company => text()();

  TextColumn get homeAddress => text()();
}

@UseMoor(tables: [])
class AppDatabase extends _$AppDatabase {
  static const String databaseName = 'rapid_pass.sqlite';

  AppDatabase()
      : super(FlutterQueryExecutor.inDatabaseFolder(path: databaseName));

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
}
