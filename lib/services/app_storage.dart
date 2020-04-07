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
    secureStorage.write(key: _masterQrCodeKey, value: masterQrCode);
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
