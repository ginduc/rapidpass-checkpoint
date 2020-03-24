import 'dart:convert';

final crockford = CrockfordCodec();

class CrockfordCodec extends Codec<int, String> {
  @override
  // TODO: implement decoder
  Converter<String, int> get decoder => null;

  @override
  Converter<int, String> get encoder => CrockfordEncoder();
}

const encoding = '0123456789ABCDEFGHJKMNPQRSTVWXYZ';

class CrockfordEncoder extends Converter<int, String> {
  @override
  String convert(int input) {
    // TODO: implement convert
    return '';
  }
}
