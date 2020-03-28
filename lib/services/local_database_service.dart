import 'package:meta/meta.dart';
import 'package:rapidpass_checkpoint/data/app_database.dart';

abstract class ILocalDatabaseService {
  Future<List<QrDataEntry>> getAllQrData();
  Stream<List<QrDataEntry>> streamQrData();
  Future<QrDataEntry> insertQrCode(QrDataEntry entry);
  Future<QrDataEntry> updateQrCode(QrDataEntry entry);
  Future<QrDataEntry> deleteQrCode(QrDataEntry entry);
}

// TODO: Additional logic while retrieving the data from local db should be placed here
class LocalDatabaseService implements ILocalDatabaseService {
  final AppDatabase appDatabase;

  LocalDatabaseService({@required this.appDatabase});

  @override
  Future<List<QrDataEntry>> getAllQrData() {
    return appDatabase.getAllQrData();
  }

  @override
  Stream<List<QrDataEntry>> streamQrData() {
    return appDatabase.streamQrData();
  }

  @override
  Future<QrDataEntry> insertQrCode(QrDataEntry entry) async {
    await appDatabase.insertQrCode(entry);
    return entry;
  }

  @override
  Future<QrDataEntry> updateQrCode(QrDataEntry entry) async {
    await appDatabase.updateQrCode(entry);
    return entry;
  }

  @override
  Future<QrDataEntry> deleteQrCode(QrDataEntry entry) async {
    await appDatabase.deleteQrCode(entry);
    return entry;
  }
}
