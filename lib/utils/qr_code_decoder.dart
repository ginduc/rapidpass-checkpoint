import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:rapidpass_checkpoint/models/control_code.dart';
import 'package:rapidpass_checkpoint/models/qr_data.dart';

/// Character '0'.
const int $0 = 0x30;

/// Character 'a'
const int $a = 0x61;

/// Character 'f'
const int $f = 0x66;

class QrCodeDecoder extends Converter<ByteData, QrData> {
  final AsciiDecoder asciiDecoder = AsciiDecoder();

  @override
  QrData convert(ByteData input) {
    debugPrint('input.lengthInBytes: ${input.lengthInBytes}');
    if (input.lengthInBytes < 13) {
      throw FormatException(
          'Invalid QR code raw data: ${input.buffer.asUint8List()}',
          input,
          input.lengthInBytes);
    }
    try {
      final passType = (input.getUint8(0) & 0x80 == 0x80)
          ? PassType.Vehicle
          : PassType.Individual;
      print('passType: $passType');
      final aporBytes = [input.getUint8(0) & 0x7f, input.getUint8(1)];
      final apor = asciiDecoder.convert(aporBytes);
      final controlCode = input.getUint32(2);
      print('controlCode: $controlCode (${ControlCode.encode(controlCode)})');
      final validFrom = input.getUint32(6);
      final validUntil = input.getUint32(10);
      final idOrPlateLen = input.getUint8(14);
      debugPrint('idOrPlateLen: $idOrPlateLen');
      final List<int> bytes = List(idOrPlateLen);
      for (var i = 0; i < idOrPlateLen; ++i) {
        bytes[i] = input.getUint8(15 + i);
      }
      final String idOrPlate = asciiDecoder.convert(bytes);
      final int signature = input.getUint32(15 + idOrPlateLen);
      return QrData(
          passType: passType,
          apor: apor,
          controlCode: controlCode,
          validFrom: validFrom,
          validUntil: validUntil,
          idOrPlate: idOrPlate,
          signature: signature);
    } catch (e) {
      throw FormatException(e.toString());
    }
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
