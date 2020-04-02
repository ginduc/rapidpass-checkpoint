import 'package:rapidpass_checkpoint/services/api_service.dart';
import 'package:rapidpass_checkpoint/services/local_database_service.dart';
import 'package:meta/meta.dart';

abstract class IApiRepository {
  Future<void> authenticateDevice(int timestamp, int pageSize, int pageNum);
  Future<void> registerDevice();
  Future<void> getRegisteredDeviceDetails(String deviceId);
  Future<void> getBatchPasses();
  Future<void> getBatchPass(String refId);
  Future<void> getQrCode(String refId);
  Future<void> verifyPlateNumber(String plateNumber);
  Future<void> verifyControlNumber(String controlNumber);
}

class ApiRepository extends IApiRepository {
  final ApiService apiService;
  final LocalDatabaseService localDatabaseService;

  ApiRepository({
    @required this.apiService,
    @required this.localDatabaseService,
  });

  @override
  Future<void> authenticateDevice(int timestamp, int pageSize, int pageNum) {
    // TODO: implement authenticateDevice
    return apiService.authenticateDevice(timestamp, pageSize, pageNum);
  }

  @override
  Future<void> getBatchPass(String refId) {
    // TODO: implement getBatchPass
    return apiService.getBatchPass(refId);
  }

  @override
  Future<void> getBatchPasses() {
    // TODO: implement getBatchPasses
    return apiService.getBatchPasses();
  }

  @override
  Future<void> getQrCode(String refId) {
    // TODO: implement getQrCode
    return apiService.getQrCode(refId);
  }

  @override
  Future<void> getRegisteredDeviceDetails(String deviceId) {
    // TODO: implement getRegisteredDeviceDetails
    return apiService.getRegisteredDeviceDetails(deviceId);
  }

  @override
  Future<void> registerDevice() {
    // TODO: implement registerDevice
    return apiService.registerDevice();
  }

  @override
  Future<void> verifyControlNumber(String controlNumber) {
    // TODO: implement verifyControlNumber
    return apiService.verifyControlNumber(controlNumber);
  }

  @override
  Future<void> verifyPlateNumber(String plateNumber) {
    // TODO: implement verifyPlateNumber
    return apiService.verifyPlateNumber(plateNumber);
  }
}
