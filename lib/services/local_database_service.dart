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

  // Retrieves all QR code data from the database per method call.
  // Please see [FutureBuilder](https://api.flutter.dev/flutter/widgets/FutureBuilder-class.html)
  @override
  Future<List<QrDataEntry>> getAllQrData() {
    return appDatabase.getAllQrData();
  }

  // Subscribes and listens to the latest changes in the database.
  // Please see [StreamBuilder](https://api.flutter.dev/flutter/widgets/StreamBuilder-class.html).
  @override
  Stream<List<QrDataEntry>> streamQrData() {
    return appDatabase.streamQrData();
  }

  // Inserts new record to the database.
  // Returns the previously inserted record (eg. used for displaying additional confirmatio prompts).
  @override
  Future<QrDataEntry> insertQrCode(QrDataEntry entry) async {
    await appDatabase.insertQrCode(entry);
    return entry;
  }

  // Replaces an existing record from the database.
  // Returns the previously inserted record (eg. used for displaying additional confirmatio prompts).
  @override
  Future<QrDataEntry> updateQrCode(QrDataEntry entry) async {
    await appDatabase.updateQrCode(entry);
    return entry;
  }

  // Deletes an existing record from the database.
  // Returns the previously inserted record (eg. used for displaying additional confirmatio prompts).
  @override
  Future<QrDataEntry> deleteQrCode(QrDataEntry entry) async {
    await appDatabase.deleteQrCode(entry);
    return entry;
  }
}
