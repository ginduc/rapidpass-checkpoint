import 'package:rapidpass_checkpoint/models/qr_data.dart';

class ValidationError {
  final String source;
  final String errorMessage;

  ValidationError(this.errorMessage, {this.source});
}

class ScanResults {
  final QrData qrData;
  final List<ValidationError> errors = List();

  ScanResults(this.qrData);

  ValidationError findErrorForSource(final String source) {
    for (final error in this.errors) {
      if (error.source == source) {
        return error;
      }
    }
    return null;
  }
}
