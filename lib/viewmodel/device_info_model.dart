import 'package:device_id/device_id.dart';
import 'package:flutter/material.dart';
import 'package:imei_plugin/imei_plugin.dart';

class DeviceInfoModel extends ChangeNotifier {
  String _imei;
  String _deviceId;
  String platformImei;
  
  Future<String> getImei() async {
     platformImei = await ImeiPlugin.getImei( shouldShowRequestPermissionRationale: false );
    _imei = await ImeiPlugin.getImei();
    debugPrint('imei => $_imei');
    return _imei;
  }

  Future<String> getDeviceId() async {
    _deviceId = await DeviceId.getID;
    debugPrint('deviceId => $_deviceId');
    return _deviceId;
  }
}
