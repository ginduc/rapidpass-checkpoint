import 'package:convert/convert.dart';
import 'package:moor/moor.dart';
import 'package:pointycastle/api.dart';
import 'package:pointycastle/block/aes_fast.dart';
import 'package:pointycastle/stream/ctr.dart';

class Aes {
  static Uint8List encrypt({Uint8List key, Uint8List plainText}) {
    final iv = hex.decode('00') as Uint8List;
    final aes = AESFastEngine();
    final cipher = CTRStreamCipher(aes);
    cipher.init(true, ParametersWithIV(KeyParameter(key), iv));
    return cipher.process(plainText);
  }

  static Uint8List decrypt({Uint8List key, Uint8List cipherText}) {
    final iv = hex.decode('00') as Uint8List;
    final aes = AESFastEngine();
    final cipher = CTRStreamCipher(aes);
    cipher.init(false, ParametersWithIV(KeyParameter(key), iv));
    return cipher.process(cipherText);
  }
}
