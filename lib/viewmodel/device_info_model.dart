import 'package:device_id/device_id.dart';
import 'package:flutter/material.dart';
import 'package:imei_plugin/imei_plugin.dart';

class DeviceInfoModel extends ChangeNotifier {
  String _imei;
  String _deviceId;
  String platformImei;
 
  DeviceInfoModel() {
    Future<String> platformImei = initPermission();
    debugPrint('initialized imei => $_imei');
  }
  
  Future<String> initPermission() async {
      return platformImei = await ImeiPlugin.getImei( shouldShowRequestPermissionRationale: false );
  }

  Future<String> getImei() async {
   
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
