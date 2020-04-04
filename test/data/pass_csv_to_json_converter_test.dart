import 'package:rapidpass_checkpoint/data/app_database.dart';
import 'package:rapidpass_checkpoint/data/pass_csv_to_json_converter.dart';
import 'package:test/test.dart';

void main() {
  test('PassCsvToJsonConverter.convert() works', () {
    final headers = [
      'APORTYPE',
      'CONTROLCODE',
      'IDENTIFIERNUMBER',
      'IDTYPE',
      'ISSUEDON',
      'PASSTYPE',
      'STATUS',
      'VALIDFROM',
      'VALIDUNTIL'
    ];
    final PassCsvToJsonConverter converter =
        PassCsvToJsonConverter(headers: headers);
    final json = converter.convert([
      'GR',
      '1P0PAADK',
      'BPC 179',
      'PersonalID',
      1585894092,
      'INDIVIDUAL',
      'APPROVED',
      1585898891,
      1586707199
    ]);
    print(json);
    final validPass = ValidPass.fromJson(json);
    print(validPass.createCompanion(true));
  });
}
