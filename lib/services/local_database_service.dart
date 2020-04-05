import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:moor/moor.dart';
import 'package:rapidpass_checkpoint/data/app_database.dart';
import 'package:rapidpass_checkpoint/models/control_code.dart';
import 'package:rapidpass_checkpoint/services/app_storage.dart';
import 'package:rapidpass_checkpoint/utils/aes.dart';

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
    debugPrint(
        'getValidPassByIntegerControlCode($controlCodeAsInt [${ControlCode.encode(controlCodeAsInt)}])');
    return appDatabase.getValidPass(controlCodeAsInt).then((validPass) async {
      debugPrint('validPass: $validPass');
      if (validPass == null) {
        return null;
      } else {
        final Uint8List encryptionKey =
            await AppStorage.getDatabaseEncryptionKey();
        return decryptIdOrPlate(encryptionKey, validPass);
      }
    });
  }

  // Close and clear all expensive resources needed as this class gets killed.
  @override
  void dispose() async {
    await appDatabase.close();
  }

  @override
  Future<int> insertValidPass(final ValidPassesCompanion companion) async {
    final Uint8List encryptionKey = await AppStorage.getDatabaseEncryptionKey();
    final ValidPassesCompanion encrypted =
        encryptIdOrPlate(encryptionKey, companion);
    return appDatabase.insertValidPass(encrypted);
  }

  ValidPassesCompanion encryptIdOrPlate(
      final Uint8List encryptionKey, final ValidPassesCompanion companion) {
    if (companion == null) {
      return null;
    }
    debugPrint('companion.idOrPlate.value: ${companion?.idOrPlate?.value}');
    if (companion.idOrPlate == null ||
        companion.idOrPlate == Value.absent() ||
        companion.idOrPlate.value == null) {
      return companion.copyWith(idOrPlate: Value(''));
    }
    final Uint8List plainText = utf8.encode(companion.idOrPlate.value);
    final Uint8List encrypted =
        Aes.encrypt(key: encryptionKey, plainText: plainText);
    final String encryptedIdOrPlate = Base64Encoder().convert(encrypted);
    return companion.copyWith(idOrPlate: Value(encryptedIdOrPlate));
  }

  ValidPass decryptIdOrPlate(
      final Uint8List encryptionKey, final ValidPass validPass) {
    if (validPass == null) {
      return validPass;
    }
    if (validPass.idOrPlate == null || validPass.idOrPlate.isEmpty) {
      return validPass;
    }
    final Uint8List cipherText = Base64Decoder().convert(validPass.idOrPlate);
    final Uint8List decrypted =
        Aes.decrypt(key: encryptionKey, cipherText: cipherText);
    final String idOrPlate = utf8.decode(decrypted);
    return validPass.copyWith(idOrPlate: idOrPlate);
  }

  @override
  Future<int> countPasses() async {
    return appDatabase.countPasses();
  }

  @override
  Future bulkInsert(final List<ValidPassesCompanion> forInserting) async {
    final Uint8List encryptionKey = await AppStorage.getDatabaseEncryptionKey();
    final List<ValidPassesCompanion> noExisting = List();
    await appDatabase.batch((batch) {
      print('x: ${inspect(batch)} (${batch.runtimeType})');
      for (final fi in forInserting) {
        getValidPassByIntegerControlCode(fi.controlCode.value).then((existing) {
          print('existing: $existing');
          if (existing == null) {
            final ValidPassesCompanion encrypted =
                encryptIdOrPlate(encryptionKey, fi);
            noExisting.add(encrypted);
          }
        });
      }
    });
    print('bulkInsert.noExisting: $noExisting (${noExisting.length})');
    return await appDatabase.insertAll(noExisting);
  }
}
