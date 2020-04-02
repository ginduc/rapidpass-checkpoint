import 'package:rapidpass_checkpoint/models/scan_results.dart';

enum CheckPlateOrControlScreenModeType { plate, control }

class CheckPlateOrControlScreenArgs {
  final CheckPlateOrControlScreenModeType screenModeType;

  CheckPlateOrControlScreenArgs(this.screenModeType);
}

class CheckPlateOrControlScreenResults {
  final CheckPlateOrControlScreenModeType screenModeType;
  final ScanResults scanResults;

  CheckPlateOrControlScreenResults(this.screenModeType, this.scanResults);
}
