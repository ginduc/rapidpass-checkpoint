import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:moor/moor.dart';

class AppStorage {
  // Create storage
  static final secureStorage = new FlutterSecureStorage();

  static const _databaseEncryptionKeyKey = 'rapidPass.databaseEncryptionKey';

  static Future<Uint8List> getDatabaseEncryptionKey() async {
    return secureStorage.read(key: _databaseEncryptionKeyKey).then((value) {
      if (value != null) {
        return Base64Codec().decode(value);
      } else {
        final Uint8List key = _generateRandomEncryptionKey();
        final String encodedKey = Base64Codec().encode(key);
        debugPrint('Generated key: $key');
        secureStorage.write(key: _databaseEncryptionKeyKey, value: encodedKey);
        return key;
      }
    });
  }

  static Uint8List _generateRandomEncryptionKey() {
    final Random random = Random.secure();
    return Uint8List.fromList(
        List<int>.generate(16, (i) => random.nextInt(256)));
  }
}
