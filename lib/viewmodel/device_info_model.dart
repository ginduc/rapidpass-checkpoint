import 'package:device_id/device_id.dart';
import 'package:flutter/material.dart';

class DeviceInfoModel extends ChangeNotifier {
  String _imei;
  String _deviceId;

  Future<String> getImei() async {
    _imei = await DeviceId.getIMEI;
    debugPrint('imei => $_imei');
    return _imei;
  }

  Future<String> getDeviceId() async {
    _deviceId = await DeviceId.getID;
    debugPrint('deviceId => $_deviceId');
    return _deviceId;
  }
}
