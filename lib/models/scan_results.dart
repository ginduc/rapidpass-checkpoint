import 'package:rapidpass_checkpoint/models/qr_data.dart';

enum RapidPassField {
  passType,
  controlCode,
  apor,
  validFrom,
  validUntil,
  idOrPlate,
  signature
}

final fieldNames = {
  RapidPassField.passType: 'Pass Type',
  RapidPassField.controlCode: 'Control Code',
  RapidPassField.apor: 'APOR',
  RapidPassField.validFrom: 'Valid From',
  RapidPassField.validUntil: 'Valid Until',
  RapidPassField.signature: 'Signature'
};

String getFieldName(final RapidPassField field) {
  return fieldNames[field];
}

class ValidationError {
  final RapidPassField source;
  final String errorMessage;

  ValidationError(this.errorMessage, {this.source});
}

class ScanResults {
  final QrData qrData;
  final List<ValidationError> errors = List();
  String resultMessage;
  bool allRed = false;

  ScanResults(this.qrData,
      {this.resultMessage = 'Pass Ok', this.allRed = false});

  List<ValidationError> addError(String errorMessage, {RapidPassField source}) {
    this.errors.add(ValidationError(errorMessage, source: source));
  }

  ValidationError findErrorForSource(final RapidPassField source) {
    for (final error in this.errors) {
      if (error.source == source) {
        return error;
      }
    }
    return null;
  }

  bool isValid() {
    return this.errors.isEmpty;
  }
}
