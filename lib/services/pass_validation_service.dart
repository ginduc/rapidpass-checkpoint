import 'package:rapidpass_checkpoint/models/qr_data.dart';
import 'package:rapidpass_checkpoint/models/scan_results.dart';

class PassValidationService {
  static ScanResults validate(final QrData qrData) {
    final results = ScanResults(qrData);
    final DateTime now = DateTime.now();
    if (now.isBefore(qrData.validFromDateTime())) {
      results.resultMessage = 'Invalid Pass';
      results.addError(
          'Pass is only valid starting on ${qrData.validFromDisplayDate()}',
          source: RapidPassField.validFrom);
    }
    if (now.isAfter(qrData.validUntilDateTime())) {
      results.resultMessage = 'Pass Expired';
      results.addError('Pass expired on ${qrData.validUntilDisplayTimestamp()}',
          source: RapidPassField.validUntil);
    }
    return results;
  }
}
