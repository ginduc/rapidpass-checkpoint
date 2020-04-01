import 'package:device_id/device_id.dart';
import 'package:flutter/material.dart';
import 'package:imei_plugin/imei_plugin.dart';
import 'package:flutter/services.dart';

class DeviceInfoModel extends ChangeNotifier {
  String _imei;
  String get imei => _imei;
  String _deviceId;
  String platformImei;

  DeviceInfoModel() {
    Future<String> platformImei = initPermission();
    debugPrint('initialized imei => $_imei');
  }

  Future<String> initPermission() async {
    try {
      platformImei =
          await ImeiPlugin.getImei(shouldShowRequestPermissionRationale: false);
    } on PlatformException {
      platformImei = 'Failed to get platform version.';
    }
    return platformImei;
  }

  Future<String> getImei() async {
    _imei = await ImeiPlugin.getImei();
    debugPrint('imei => $_imei');
    notifyListeners();
    return _imei;
  }

  Future<String> getDeviceId() async {
    _deviceId = await DeviceId.getID;
    debugPrint('deviceId => $_deviceId');
    return _deviceId;
  }
}
