import 'package:rapidpass_checkpoint/models/qr_data.dart';
import 'package:rapidpass_checkpoint/models/scan_results.dart';

class PassValidationService {
  static ScanResults validate(final QrData qrData) {
    final results = ScanResults(qrData);
    final DateTime now = DateTime.now();
    if (now.isBefore(qrData.validFromDateTime())) {
      results.addError('ValidFrom', source: RapidPassField.validFrom);
    }
    return results;
  }
}
