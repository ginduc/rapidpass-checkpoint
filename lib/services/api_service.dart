import 'package:meta/meta.dart';
import 'package:http/http.dart';

abstract class IApiService {
  Future<void> authenticateDevice(int timestamp, int pageSize, int pageNum);
  Future<void> registerDevice();
  Future<void> getRegisteredDeviceDetails(String deviceId);
  Future<void> getBatchPasses();
  Future<void> getBatchPass(String refId);
  Future<void> getQrCode(String refId);
  Future<void> verifyPlateNumber(String plateNumber);
  Future<void> verifyControlNumber(String controlNumber);
}

class ApiService extends IApiService {
  final Client client;
  final String baseUrl;

  ApiService({
    @required this.client,
    @required this.baseUrl,
  });

  @override
  Future<void> authenticateDevice(int timestamp, int pageSize, int pageNum) {
    // TODO: implement authenticateDevice
    return null;
  }

  @override
  Future<void> getBatchPass(String refId) {
    // TODO: implement getBatchPass
    return null;
  }

  @override
  Future<void> getBatchPasses() {
    // TODO: implement getBatchPasses
    return null;
  }

  @override
  Future<void> getQrCode(String refId) {
    // TODO: implement getQrCode
    return null;
  }

  @override
  Future<void> getRegisteredDeviceDetails(String deviceId) {
    // TODO: implement getRegisteredDeviceDetails
    return null;
  }

  @override
  Future<void> registerDevice() {
    // TODO: implement registerDevice
    return null;
  }

  @override
  Future<void> verifyControlNumber(String controlNumber) {
    // TODO: implement verifyControlNumber
    return null;
  }

  @override
  Future<void> verifyPlateNumber(String plateNumber) {
    // TODO: implement verifyPlateNumber
    return null;
  }
}
