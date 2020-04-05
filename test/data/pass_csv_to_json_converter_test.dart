import 'package:rapidpass_checkpoint/data/app_database.dart';
import 'package:rapidpass_checkpoint/data/pass_csv_to_json_converter.dart';
import 'package:test/test.dart';

void main() {
  test('PassCsvToJsonConverter.convert() works', () {
    final headers = [
      'passType',
      'aporType',
      'controlCode',
      'name',
      'status',
      'idType',
      'identifierNumber',
      'plateNumber',
      'validFrom',
      'validTo',
      'issuedBy'
    ];
    final PassCsvToJsonConverter converter =
        PassCsvToJsonConverter(headers: headers);
    final json = converter.convert([
      'VEHICLE',
      'ME',
      '20HAYPV9',
      'Isabel Namoro',
      'APPROVED',
      'PLT',
      '987654322',
      'TST1234',
      1586082395,
      1586707199,
      null
    ]);
    print(json);
    final validPass = ValidPass.fromJson(json);
    print(validPass.createCompanion(true));
  });
}
