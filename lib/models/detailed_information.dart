class DetailedInformation {
  DetailedInformation({
    this.controlNumber,
    this.plateNumber,
    this.accessType,
    this.approvedBy,
    this.validUntil,
    this.lastUsed,
    this.reason,
    this.fullName,
    this.email,
    this.mobileNumber,
    this.companyName,
    this.idType,
    this.idNumber,
    this.origin,
    this.destination
  });

  final String controlNumber, plateNumber,
                accessType, approvedBy,
                validUntil, lastUsed,
                reason;
  final String fullName, email, mobileNumber;
  final String companyName, idType, idNumber;
  final Location origin, destination;
}

class Location {
  Location({
    this.streetName,
    this.cityName,
    this.province
  });

  final String streetName, cityName, province;
}