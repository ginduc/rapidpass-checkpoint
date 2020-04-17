import 'package:rapidpass_checkpoint/models/qr_data.dart';

enum RapidPassField {
  passType,
  controlCode,
  apor,
  validFrom,
  validUntil,
  idOrPlate,
  status,
  signature
}

final fieldNames = {
  RapidPassField.passType: 'Pass Type',
  RapidPassField.controlCode: 'Control Number',
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
  String resultSubMessage;
  bool allRed = false;

  static final invalidPass =
      ScanResults(null, resultMessage: 'ENTRY DENIED', allRed: true)
          .addError('ENTRY DENIED');

  ScanResults(this.qrData,
      {this.resultMessage = 'ENTRY APPROVED',
      this.allRed = false,
      String resultSubMessage});

  ScanResults addError(String errorMessage, {RapidPassField source}) {
    this.errors.add(ValidationError(errorMessage, source: source));
    return this;
  }

  ValidationError findErrorForSource(final RapidPassField source) {
    for (final error in this.errors) {
      if (error.source == source) {
        return error;
      }
    }
    return null;
  }

  bool get isValid => this.errors.isEmpty;
}
