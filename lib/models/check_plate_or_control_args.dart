import 'package:rapidpass_checkpoint/models/scan_results.dart';

enum CheckPlateOrControlScreenModeType { plate, control }

class CheckPlateOrControlScreenResults {
  final CheckPlateOrControlScreenModeType screenModeType;
  final ScanResults scanResults;

  CheckPlateOrControlScreenResults(this.screenModeType, this.scanResults);
}
