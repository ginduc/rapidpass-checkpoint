import 'dart:convert';
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:pointycastle/api.dart';
import 'package:pointycastle/block/aes_fast.dart';
import 'package:pointycastle/block/modes/ecb.dart';
import 'package:pointycastle/padded_block_cipher/padded_block_cipher_impl.dart';
import 'package:pointycastle/stream/ctr.dart';
import 'package:rapidpass_checkpoint/utils/aes.dart';
import 'package:test/test.dart';

void main() {
  test('Aes.encrypt() and decrypt() works', () {
    final plainText = Uint8List.fromList(utf8.encode('ABC1234'));
    final key = hex.decode('d099294ebdae6763ba75d386eae517aa') as Uint8List;

    final Uint8List cipherText = Aes.encrypt(key: key, plainText: plainText);
    final String expected = 'bBuDrx0ZFg==';
    expect(Base64Codec().encode(cipherText), equals(expected));

    final Uint8List decrypted = Aes.decrypt(key: key, cipherText: cipherText);
    expect(utf8.decode(decrypted), equals('ABC1234'));
  });

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
    final PaddedBlockCipher pbc = PaddedBlockCipherImpl(padding, cipher);

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
}
