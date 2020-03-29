import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';

final key = hex
    .decode('a993cb123b3ba87bf06c22365bfa0951e2521fcff5990b42dacf7c4b55e83a42');

class HmacShac256 {
  static bool validateSignature(final Uint8List decodedFromBase64) {
    final length = decodedFromBase64.lengthInBytes;
    print('decodedFromBase64: $decodedFromBase64');
    print('length: $length');
    if (length < 4) {
      return false;
    }
    final unsignedData = decodedFromBase64.sublist(0, length - 4);
    final digest = computeSignature(key, unsignedData);
    final ffDigest = digest.bytes.sublist(0, 4);
    print('ffDigest: $ffDigest');
    final ffInput = decodedFromBase64.sublist(length - 4, length);
    print('ffInput: $ffInput');
    return listEquals(ffInput, ffDigest);
  }

  static Digest computeSignature(final Uint8List key, final Uint8List data) {
    final hmac = new Hmac(sha256, key);
    return hmac.convert(data);
  }
}
