import 'package:meta/meta.dart';
import 'package:rapidpass_checkpoint/data/app_database.dart';
import 'package:rapidpass_checkpoint/models/control_code.dart';

abstract class ILocalDatabaseService {
  Future<int> countPasses();
  Future<ValidPass> streamValidPassByStringControlCode(
      final String controlCode);
  Future<ValidPass> streamValidPassByIntegerControlCode(
      final int controlNumber);
  Future<int> insertValidPass(final ValidPassesCompanion companion);
  void dispose();
}

// TODO: Additional logic while retrieving the data from local db should be placed here
class LocalDatabaseService implements ILocalDatabaseService {
  final AppDatabase appDatabase;

  LocalDatabaseService({@required this.appDatabase});

  @override
  Future<ValidPass> streamValidPassByStringControlCode(
      final String controlCode) {
    return streamValidPassByIntegerControlCode(ControlCode.decode(controlCode));
  }

  @override
  Future<ValidPass> streamValidPassByIntegerControlCode(
      final int controlCodeAsInt) {
    return appDatabase.streamValidPass(controlCodeAsInt).first;
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
}
