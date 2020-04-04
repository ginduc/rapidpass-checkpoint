import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:rapidpass_checkpoint/models/control_code.dart';
import 'package:rapidpass_checkpoint/services/api_service.dart';
import 'package:rapidpass_checkpoint/services/local_database_service.dart';

abstract class IApiRepository {
  Future<void> authenticateDevice(int timestamp, int pageSize, int pageNum);
  Future<void> registerDevice();
  Future<void> getRegisteredDeviceDetails(String deviceId);
  Future<void> batchDownloadAndInsertPasses();
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
  Future<void> batchDownloadAndInsertPasses() async {
    final int before = await localDatabaseService.countPasses();
    debugPrint('before: $before');
    try {
      final companions = await apiService.getBatchPasses();
      companions.forEach((companion) async {
        var controlCodeNumber = companion.controlCode.value;
        final validPass = await localDatabaseService
            .streamValidPassByIntegerControlCode(controlCodeNumber);
        if (validPass == null) {
          debugPrint(
              "Control code ${ControlCode.encode(controlCodeNumber)} not found in local database, inserting...");
          await localDatabaseService.insertValidPass(companion);
        } else {
          debugPrint(
              "Control code ${ControlCode.encode(controlCodeNumber)} already found in local database, skipping...");
        }
      });
    } catch (e) {
      debugPrint(e);
    }
    final int after = await localDatabaseService.countPasses();
    debugPrint('after: $after');
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
