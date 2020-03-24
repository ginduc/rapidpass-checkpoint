class RapidPass {
  final bool isVehiclePass;
  final String purposeCode;
  final int controlCode;
  final DateTime validFrom;
  final DateTime validUntil;
  final String idOrPlate;
  RapidPass(this.isVehiclePass, this.purposeCode, this.controlCode,
      this.validFrom, this.validUntil, this.idOrPlate);

  /// Returns the control code encoded using Crockford's Base32
  String controlCodeAsString() {}
}
