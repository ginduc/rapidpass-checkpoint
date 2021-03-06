import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:rapidpass_checkpoint/models/app_secrets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppStorage {
  // Create storage
  static final secureStorage = new FlutterSecureStorage();

  static const _masterQrCodeKey = 'rapidPass.masterQrCode';
  static const _databaseEncryptionKeyKey = 'rapidPass.databaseEncryptionKey';
  static const _signingKeyKey = 'rapidPass.signingKey';
  static const _encryptionKeyKey = 'rapidPass.encryptionKey';
  static const _accessCodeKey = 'rapidPass.accessCode';

  static Future<void> setMasterQrCode(final String masterQrCode) async {
    if (masterQrCode == null) return;
    return secureStorage.write(key: _masterQrCodeKey, value: masterQrCode);
  }

  static Future<void> resetMasterQrCode() {
    return secureStorage.delete(key: _masterQrCodeKey);
  }

  static Future<String> getMasterQrCode() {
    return secureStorage.read(key: _masterQrCodeKey);
  }

  static Future<int> getLastSyncOn() =>
      SharedPreferences.getInstance().then((prefs) =>
          prefs.containsKey('lastSyncOn') ? prefs.getInt('lastSyncOn') : 0);

  static Future<int> setLastSyncOnToNow() {
    final DateTime now = DateTime.now();
    final int timestamp = now.millisecondsSinceEpoch ~/ 1000;
    debugPrint('timestamp: $timestamp');
    return SharedPreferences.getInstance().then((prefs) =>
        prefs.setInt('lastSyncOn', timestamp).then((_) => timestamp));
  }

  static Future<AppSecrets> setAppSecrets(final AppSecrets appSecrets) {
    return Future.wait([
      secureStorage.write(key: _signingKeyKey, value: appSecrets.signingKey),
      secureStorage.write(
          key: _encryptionKeyKey, value: appSecrets.encryptionKey),
      secureStorage.write(key: _accessCodeKey, value: appSecrets.accessCode)
    ]).then((_) {
      debugPrint('AppSecrets saved!');
      return appSecrets;
    });
  }

  static Future<AppSecrets> getAppSecrets() {
    return Future.wait([
      secureStorage.read(key: _signingKeyKey),
      secureStorage.read(key: _encryptionKeyKey),
      secureStorage.read(key: _accessCodeKey)
    ]).then((res) {
      debugPrint('appSecrets: ' + res.toString());

      if (res[0] == null || res[1] == null || res[2] == null) {
        return null;
      } else {
        return AppSecrets(
            signingKey: res[0], encryptionKey: res[1], accessCode: res[2]);
      }
    }).catchError((e) {
      throw (null);
    });
  }

  static Future<Uint8List> getDatabaseEncryptionKey() =>
      secureStorage.read(key: _databaseEncryptionKeyKey).then((value) {
        if (value != null) {
          return Base64Codec().decode(value);
        } else {
          final Uint8List key = generateRandomEncryptionKey();
          final String encodedKey = Base64Codec().encode(key);
          debugPrint('Generated key: $key');
          secureStorage.write(
              key: _databaseEncryptionKeyKey, value: encodedKey);
          return key;
        }
      });

  @visibleForTesting
  static Uint8List generateRandomEncryptionKey() {
    final Random random = Random.secure();
    return Uint8List.fromList(
        List<int>.generate(16, (i) => random.nextInt(256)));
  }
}
