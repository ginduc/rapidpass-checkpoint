import 'package:flutter/material.dart';
import 'package:device_id/device_id.dart';

class DeviceInfoModel extends ChangeNotifier {
  String _imei;
  String _uuid;

  Future<String> getImei() async {
    _imei = await DeviceId.getIMEI;
    debugPrint('imei => $_imei');
    debugPrint('uuid => $_uuid');
    return _imei;
  }

  Future<String> getDeviceId() async {
    _uuid = await DeviceId.getID;
    debugPrint('deviceId => $_imei');
    return _imei;
  }
}
