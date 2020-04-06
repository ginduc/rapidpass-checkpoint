import 'dart:convert';

import 'package:rapidpass_checkpoint/models/control_code.dart';

class PassCsvToJsonConverter
    extends Converter<List<Object>, Map<String, dynamic>> {
  final List<String> headers;

  PassCsvToJsonConverter({this.headers});

  @override
  Map<String, dynamic> convert(final List<dynamic> input) {
    final Map<String, dynamic> json = Map();
    for (int i = 0; i < input.length; ++i) {
      map(json, headers[i], input[i]);
    }
    return json;
  }

  final toJsonMapping = {
    'aporType': 'apor',
    'controlCode': 'controlCode',
    'plateNumber': 'idOrPlate',
    'idType': 'idType',
    'status': 'status',
    'validFrom': 'validFrom',
    'validTo': 'validUntil'
  };

  void map(Map<String, dynamic> json, String header, dynamic value) {
    switch (header) {
      case 'controlCode':
        json['controlCode'] = ControlCode.decode(value);
        break;
      case 'passType':
        json['passType'] = (value == 'VEHICLE') ? 1 : 0;
        break;
      case 'validFrom':
        json['validFrom'] = value;
        break;
      case 'validTo':
        json['validUntil'] = value;
        break;
      default:
        json[toJsonMapping[header]] = value as String;
    }
  }
}
