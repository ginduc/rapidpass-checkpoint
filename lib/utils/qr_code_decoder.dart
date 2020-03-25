import 'dart:typed_data';

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
}

class QrCodeDecoder {
  static QrData decodeQrData(ByteData bytes) {}

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
