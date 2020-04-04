import 'package:meta/meta.dart';
import 'package:rapidpass_checkpoint/data/app_database.dart';
import 'package:rapidpass_checkpoint/models/control_code.dart';

abstract class ILocalDatabaseService {
  Future<ValidPass> streamValidPass(final String controlCode);
  void dispose();
}

// TODO: Additional logic while retrieving the data from local db should be placed here
class LocalDatabaseService implements ILocalDatabaseService {
  final AppDatabase appDatabase;

  LocalDatabaseService({@required this.appDatabase});

  @override
  Future<ValidPass> streamValidPass(final String controlCode) {
    final int controlCodeNumber = ControlCode.decode(controlCode);
    return appDatabase.streamValidPass(controlCodeNumber).first;
  }

  // Close and clear all expensive resources needed as this class gets killed.
  @override
  void dispose() async {
    await appDatabase.close();
  }
}
