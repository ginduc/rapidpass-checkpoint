import 'dart:io';
import 'package:device_id/device_id.dart';
import 'package:flutter/material.dart';
import 'package:imei_plugin/imei_plugin.dart';
import 'package:flutter/services.dart';
import 'package:device_info/device_info.dart';
import 'package:rapidpass_checkpoint/utils/imei_generator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeviceInfoModel extends ChangeNotifier {
  String _imei;
  String get imei => _imei;
  String _deviceId;
  String platformImei;

  DeviceInfoModel() {
    // Future<String> platformImei = initPermission();
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
    //_imei = await ImeiPlugin.getImei();

    // refactor or crash detection suggestion welcome

    if (Platform.isAndroid) {
      final prefs = await SharedPreferences
          .getInstance(); // it survived app update, not survived data on app uninstall.

      AndroidDeviceInfo androidInfo = await DeviceInfoPlugin().androidInfo;

      int sdkInt = androidInfo.version.sdkInt;

      String storedIMEI = prefs.getString("IMEI");

      if (storedIMEI != null) {
        debugPrint("Stored IMEI found");
        _imei = storedIMEI;
      } else {
        debugPrint("No IMEI found, query for one");

        _imei = (sdkInt < 29)
            ? await ImeiPlugin.getImei()
            : IMEIGenerator.generateIMEI();

        prefs.setString("IMEI", _imei); // Store it for future uses
      }
    }

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
