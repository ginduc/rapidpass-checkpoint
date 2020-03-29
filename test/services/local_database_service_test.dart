import 'package:moor_ffi/moor_ffi.dart';
import 'package:rapidpass_checkpoint/data/app_database.dart';
import 'package:rapidpass_checkpoint/services/local_database_service.dart';
import 'package:test/test.dart';

void main() {
  AppDatabase database;
  LocalDatabaseService localDatabaseService;

  setUp(() {
    database = AppDatabase(VmDatabase.memory());
    localDatabaseService = LocalDatabaseService(appDatabase: database);
  });
  tearDown(() async {
    localDatabaseService.dispose();
  });

  group('LocalDatabaseService test group', () {
    test('QrDataEntry can be created', () async {
      // Arrange
      final entry = QrDataEntry(
        id: 1,
        controlCode: 1,
        validFrom: 1,
        validUntil: 1,
        idOrPlate: 1,
        company: 'Malacañang',
        homeAddress: "Manila",
      );

      // Act
      final entryStored = await localDatabaseService.insertQrCode(entry);
      final entryRetrieved =
          await localDatabaseService.streamQrDataEntry(entryStored.id).first;

      // Assert
      expect(entryRetrieved, entry);
    });

    test('QrDataEntry can be updated', () async {
      // Arrange
      final entryOld = QrDataEntry(
        id: 1, // Primary ID must be the same
        controlCode: 1,
        validFrom: 1,
        validUntil: 1,
        idOrPlate: 1,
        company: 'Malacañang',
        homeAddress: "Metro",
      );

      final entryNew = QrDataEntry(
        id: 1, // Primary ID must be the same
        controlCode: 2,
        validFrom: 2,
        validUntil: 2,
        idOrPlate: 2,
        company: 'Palace',
        homeAddress: "Manila",
      );

      // Act
      // Insert old record
      await localDatabaseService.insertQrCode(entryOld);

      // Update of the old record
      final entryUpdatedNew = await localDatabaseService.updateQrCode(entryNew);
      final entryUpdatedRetrieved = await localDatabaseService
          .streamQrDataEntry(entryUpdatedNew.id)
          .first;

      // Assert
      expect(
        entryUpdatedRetrieved,
        entryUpdatedNew,
      );
    });

    test('QrDataEntry can be deleted', () async {
      // Arrange
      final entry = QrDataEntry(
        id: 1, // Primary ID must be the same
        controlCode: 1,
        validFrom: 1,
        validUntil: 1,
        idOrPlate: 1,
        company: 'Malacañang',
        homeAddress: "Metro",
      );

      // Act
      // Insert old record
      final entryStored = await localDatabaseService.insertQrCode(entry);
      final entryStoredInitially =
          await localDatabaseService.streamQrDataEntry(entryStored.id).first;

      // Delete the record
      final entryDeleted = await localDatabaseService.deleteQrCode(entryStored);
      final entryStoredAfterDeletion =
          await localDatabaseService.streamQrDataEntry(entryStored.id).first;

      // Assert
      expect(entry, entryDeleted);
      expect(
        entryStoredInitially,
        entry,
      );
      expect(
        entryStoredAfterDeletion,
        null,
      );
    });
  });
}
