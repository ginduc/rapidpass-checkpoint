import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AppStorage {
  // Create storage
  static final secureStorage = new FlutterSecureStorage();

  static const _databaseEncryptionKeyKey = 'rapidPass.databaseEncryptionKey';

  static Future<String> getDatabaseEncryptionKey() async {
    return secureStorage.read(key: _databaseEncryptionKeyKey).then((value) {
      if (value != null) {
        return value;
      } else {
        final String key = generateRandomEncryptionKey();
        debugPrint('Generated key: $key');
        secureStorage.write(key: _databaseEncryptionKeyKey, value: key);
        return key;
      }
    });
  }

  static String generateRandomEncryptionKey() {
    final Random random = Random.secure();
    var list = List<int>.generate(16, (i) => random.nextInt(256));
    return Base64Codec().encode(list);
  }
}
