import 'dart:convert';
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:flutter/cupertino.dart';
import 'package:pointycastle/api.dart';
import 'package:pointycastle/block/aes_fast.dart';
import 'package:pointycastle/stream/ctr.dart';
import 'package:rapidpass_checkpoint/models/control_code.dart';
import 'package:rapidpass_checkpoint/models/qr_data.dart';

/// Character '0'.
const int $0 = 0x30;

/// Character 'a'
const int $a = 0x61;

/// Character 'f'
const int $f = 0x66;

const AsciiDecoder asciiDecoder = const AsciiDecoder();

class QrCodeDecoder extends Converter<ByteData, QrData> {
  final Uint8List key;

  QrCodeDecoder(this.key);

  ByteData _decrypt(final ByteData rawInput) {
    final rawBuffer = rawInput.buffer.asUint8List();
    final Uint8List cipherText = rawBuffer.sublist(2, rawBuffer.length - 4);
    debugPrint('cipherText: ${hex.encode(cipherText)} (${cipherText.length})');
    final List<int> signature =
        rawBuffer.sublist(rawBuffer.length - 4, rawBuffer.length);
    debugPrint('signature: ${hex.encode(signature)} (${signature.length})');
    // Please don't do this if you need _real_ cryptographic security!
    // Use a _real_, one-time use initialization vector
    final iv = hex.decode('00') as Uint8List;
    final aes = AESFastEngine();
    final cipher = CTRStreamCipher(aes);
    cipher.init(false, ParametersWithIV(KeyParameter(key), iv));

    final plainText = cipher.process(cipherText);
    debugPrint('plainText: ${hex.encode(plainText)} (${plainText.length})');

    final Uint8List plainTextWithSignature =
        Uint8List.fromList(plainText + signature);
    return plainTextWithSignature.buffer.asByteData();
  }

  String getStringFromBytes(final ByteData input, final int offset) {
    final len = input.getUint8(offset);
    final List<int> bytes = List(len);
    for (var i = 0; i < len; ++i) {
      bytes[i] = input.getUint8(offset + 1 + i);
    }
    return asciiDecoder.convert(bytes);
  }

  @override
  QrData convert(final ByteData rawInput) {
    debugPrint(
        'rawInput: ${hex.encode(rawInput.buffer.asUint8List())} (${rawInput.lengthInBytes})');
    ByteData input;
    // 'Magic marker' bytes for v2 encrypted QR Code
    if (rawInput.getUint8(0) == 0xff && rawInput.getUint8(1) == 0xfe) {
      input = _decrypt(rawInput);
    } else {
      input = rawInput;
    }
    try {
      final inputLength = input.lengthInBytes;
      debugPrint('inputLength: $inputLength');
      final passType = (input.getUint8(0) & 0x80 == 0x80)
          ? PassType.Vehicle
          : PassType.Individual;
      debugPrint('passType: $passType');
      final aporBytes = [input.getUint8(0) & 0x7f, input.getUint8(1)];
      final apor = asciiDecoder.convert(aporBytes);
      final controlCode = input.getUint32(2);
      debugPrint(
          'controlCode: $controlCode (${ControlCode.encode(controlCode)})');
      final validFrom = input.getUint32(6);
      debugPrint('validFrom: $validFrom');
      final validUntil = input.getUint32(10);
      debugPrint('validUntil: $validUntil');
      final idOrPlateLen = input.getUint8(14);
      final String idOrPlate = getStringFromBytes(input, 14);
      debugPrint('idOrPlate: $idOrPlate');
      final int signature = input.getUint32(inputLength - 4);
      if (inputLength > 15 + idOrPlateLen + 4) {
        final String name = getStringFromBytes(input, 15 + idOrPlateLen);
        debugPrint('name: $name');
        return QrData(
            passType: passType,
            apor: apor,
            controlCode: controlCode,
            validFrom: validFrom,
            validUntil: validUntil,
            idOrPlate: idOrPlate,
            name: name,
            signature: signature);
      } else {
        return QrData(
            passType: passType,
            apor: apor,
            controlCode: controlCode,
            validFrom: validFrom,
            validUntil: validUntil,
            idOrPlate: idOrPlate,
            signature: signature);
      }
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
