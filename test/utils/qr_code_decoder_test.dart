import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:moor/moor.dart';
import 'package:pointycastle/api.dart';
import 'package:pointycastle/block/aes_fast.dart';
import 'package:pointycastle/block/modes/ecb.dart';
import 'package:pointycastle/export.dart';
import 'package:rapidpass_checkpoint/models/qr_data.dart';
import 'package:rapidpass_checkpoint/utils/qr_code_decoder.dart';
import 'package:test/test.dart';

void main() {
  test('AES CTR', () {
    final qrData = hex.decode('ea16541bafa97c4a7663282c5de52f5e8df11339dbb1');
    final cipherText = qrData.sublist(2, qrData.length);
    print('cipherText: ${hex.encode(cipherText)} (${cipherText.length})');
    final key = hex.decode('d099294ebdae6763ba75d386eae517aa') as Uint8List;
    final iv = hex.decode('00') as Uint8List;
    final aes = AESFastEngine();
    final cipher = CTRStreamCipher(aes);
    cipher.init(false, ParametersWithIV(KeyParameter(key), iv));

    final plainText = cipher.process(cipherText);
    print('decrypted: ${hex.encode(plainText)}');
    expect(hex.encode(plainText),
        equals('79426f375360545ea24f2bb430bba5eedc8bf9ba'));
  });

  test('AES CBC', () {
    final qrData =
        base64.decode('//5REYpTfCFoFmuNoxj9R/ChOdO6ZlHgOqjOjgUMMMfeVg==');
    final cipherText = qrData.sublist(2, qrData.length);
    print('cipherText: ${hex.encode(cipherText)} (${cipherText.length})');
    final key = hex.decode("d099294ebdae6763ba75d386eae517aa") as Uint8List;

    final aes = AESFastEngine();
    final cipher = ECBBlockCipher(aes);
    cipher.init(false, KeyParameter(key));
    final padding = Padding('PKCS7');
    PaddedBlockCipher pbc = PaddedBlockCipherImpl(padding, cipher);

    final paddedPlainText = Uint8List(cipherText.length); // allocate space

    var offset = 0;
    while (offset < cipherText.length) {
      offset += pbc.processBlock(cipherText, offset, paddedPlainText, offset);
    }
    assert(offset == cipherText.length);
    final padCount = padding.padCount(paddedPlainText);
    print('padCount: $padCount');
    print(hex.encode(paddedPlainText));
    print(hex
        .encode(paddedPlainText.sublist(0, paddedPlainText.length - padCount)));
  });

  test('QrCodeDecoder works with new, encrypted codes', () {
    final String raw = '//7qFlQbr6l8SnZjKCxd5S9ejfETOduxDCusjQ==';
    final bytes = base64.decode(raw);
    final uint8list = bytes.buffer.asByteData();
    final qrData = QrCodeDecoder().convert(uint8list);
    expect(qrData.passType, equals(PassType.Vehicle));
    expect(qrData.apor, equals('GO'));
    expect(qrData.controlCode, equals(2491777155));
    expect(qrData.validFrom, equals(1584921600));
    expect(qrData.validUntil, equals(1585267200));
    expect(qrData.idOrPlate, equals('ABC1234'));
    expect(qrData.signature, equals(0x0c2bac8d));
  });

  test('QrCodeDecoder works with old codes', () {
    final String raw = '0EkTqZtyXlqKgF6q9gAHTkFaMjA3MGxRlmM=';
    final bytes = base64.decode(raw);
    final uint8list = bytes.buffer.asByteData();
    final qrData = QrCodeDecoder().convert(uint8list);
    expect(qrData.passType, equals(PassType.Vehicle));
    expect(qrData.apor, equals("PI"));
    expect(qrData.controlCode, equals(329882482));
    expect(qrData.validFrom, equals(1582992000));
    expect(qrData.validUntil, equals(1588262400));
    expect(qrData.idOrPlate, equals("NAZ2070"));
    expect(qrData.signature, equals(0x6c519663));
  });

  test('QrDecoder.decodeHex works', () {
    final testCases = {
      '': [],
      '00': [0],
      'f4': [0xf4],
      'fedcba9876543210': [0xfe, 0xdc, 0xba, 0x98, 0x76, 0x54, 0x32, 0x10]
    };
    testCases.forEach((hex, expected) {
      final decoded = QrCodeDecoder.decodeHex(hex);
      expect(decoded, equals(expected));
    });
  });
}
