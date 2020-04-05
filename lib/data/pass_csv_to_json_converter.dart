import 'dart:convert';

import 'package:rapidpass_checkpoint/data/app_database.dart';
import 'package:rapidpass_checkpoint/models/control_code.dart';

class PassCsvToJsonConverter
    extends Converter<List<Object>, Map<String, dynamic>> {
  final List<String> headers;

  PassCsvToJsonConverter({this.headers});

  @override
  Map<String, dynamic> convert(final List<dynamic> input) {
    ValidPassesCompanion validPass = ValidPassesCompanion();
    final Map<String, dynamic> json = Map();
    for (int i = 0; i < input.length; ++i) {
      map(json, headers[i], input[i]);
    }
    return json;
  }

  final toJsonMapping = {
    'APORTYPE': 'apor',
    'CONTROLCODE': 'controlCode',
    'IDENTIFIERNUMBER': 'idOrPlate',
    'IDTYPE': 'idType',
    'ISSUEDON': 'issuedOn',
    'STATUS': 'status',
    'VALIDFROM': 'validFrom',
    'VALIDUNTIL': 'validUntil'
  };

  void map(Map<String, dynamic> json, String header, dynamic value) {
    switch (header) {
      case 'CONTROLCODE':
        json['controlCode'] = ControlCode.decode(value);
        break;
      case 'PASSTYPE':
        json['passType'] = (value == 'VEHICLE') ? 1 : 0;
        break;
      case 'ISSUEDON':
        json['issuedOn'] = int.parse(value);
        break;
      case 'VALIDFROM':
        json['validFrom'] = int.parse(value);
        break;
      case 'VALIDUNTIL':
        json['validUntil'] = int.parse(value);
        break;
      default:
        json[toJsonMapping[header]] = value as String;
    }
  }
}
