import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';

class HmacShac256 {
  static bool validateSignature(
      final Uint8List key, final Uint8List decodedFromBase64) {
    final length = decodedFromBase64.lengthInBytes;
    print(
        'decodedFromBase64: ${hex.encode(decodedFromBase64)} ($length bytes)');
    if (length < 4) {
      return false;
    }
    final unsignedData = decodedFromBase64.sublist(0, length - 4);
    final digest = computeSignature(key, unsignedData);
    final ffDigest = digest.bytes.sublist(0, 4);
    final ffInput = decodedFromBase64.sublist(length - 4, length);
    return listEquals(ffInput, ffDigest);
  }

  static Digest computeSignature(final Uint8List key, final Uint8List data) {
    final hmac = new Hmac(sha256, key);
    return hmac.convert(data);
  }
}
