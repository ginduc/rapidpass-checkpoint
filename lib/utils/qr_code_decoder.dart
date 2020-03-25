import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';

import 'base32_crockford.dart';

/// Character '0'.
const int $0 = 0x30;

/// Character 'a'
const int $a = 0x61;

/// Character 'f'
const int $f = 0x66;

class QrData {
  final int pass_type;
  final int control_code;
  final int valid_from;
  final int valid_until;
  final String id_or_plate;
  QrData(this.pass_type, this.control_code, this.valid_from, this.valid_until,
      this.id_or_plate);
  @override
  String toString() {
    final String cc = crockford.encode(control_code);
    return "%{pass_type: $pass_type, control_code: ${cc}, valid_from: $valid_from, valid_until: $valid_until, id_or_plate: '$id_or_plate'}";
  }
}

class QrCodeDecoder extends Converter<ByteData, QrData> {
  final AsciiDecoder asciiDecoder = AsciiDecoder();

  @override
  QrData convert(ByteData input) {
    if (input.lengthInBytes < 13) {
      throw FormatException(
          'Invalid QR code raw data: ${input.buffer.asUint8List()}',
          input,
          input.lengthInBytes);
    }
    // TODO: More sanity checks
    final pass_type = input.getUint8(0);
    final control_code = input.getUint32(1);
    print('control_code: $control_code');
    final valid_from = input.getUint32(5);
    final valid_until = input.getUint32(9);
    // ZigZag encoding, but since should only be positive we can simply drop
    // the LSB.
    // TODO: Handle lengths > 64 (MSB is 1)
    final byte13 = input.getUint8(13);
    debugPrint('byte13: ${byte13.toRadixString(16)}');
    final id_or_plate_len = input.getUint8(13) >> 1;
    debugPrint('id_or_plate_len: $id_or_plate_len');
    final List<int> bytes = List(id_or_plate_len);
    for (var i = 0; i < id_or_plate_len; ++i) {
      bytes[i] = input.getUint8(14 + i);
    }
    final String id_or_plate = asciiDecoder.convert(bytes);
    return QrData(
        pass_type, control_code, valid_from, valid_until, id_or_plate);
  }

  /// Just a utility method (used mainly in dev/test) to decode a hex string
  /// into a Uint8List (which can then be turned into a `ByteData`.
  static List<int> decodeHex(String hex) {
    if (!hex.length.isEven) {
      throw new FormatException(
          'Invalid input length, must be even.', hex, hex.length);
    }
    return _decode(hex.codeUnits);
  }

  static List<int> _decode(List<int> codeUnits) {
    final targetSize = codeUnits.length ~/ 2;
    final sourceEnd = targetSize * 2;
    final list = List<int>(targetSize);
    var destIndex = 0;
    for (var sourceIndex = 0; sourceIndex < sourceEnd; sourceIndex += 2) {
      final highNibble = _decodeNibble(codeUnits, sourceIndex);
      final lowNibble = _decodeNibble(codeUnits, sourceIndex + 1);
      list[destIndex++] = (highNibble << 4) | lowNibble;
    }
    return list;
  }

  static int _decodeNibble(List<int> codeUnits, int sourceIndex) {
    final codeUnit = codeUnits.elementAt(sourceIndex);
    final digit = $0 ^ codeUnit;
    if (digit <= 9) {
      if (digit >= 0) return digit;
    } else {
      final letter = 0x20 | codeUnit;
      if ($a <= letter && letter <= $f) return letter - $a + 10;
    }

    throw FormatException(
        'Invalid hexadecimal code unit U+${codeUnit.toRadixString(16).padLeft(4, '0')} at position $sourceIndex',
        codeUnits,
        sourceIndex);
  }
}
