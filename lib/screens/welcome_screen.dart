import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:rapidpass_checkpoint/common/constants/rapid_asset_constants.dart';
import 'package:rapidpass_checkpoint/models/user_location.dart';
import 'package:rapidpass_checkpoint/screens/credits_screen.dart';
import 'package:rapidpass_checkpoint/themes/default.dart';
import 'package:rapidpass_checkpoint/viewmodel/device_info_model.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rapidpass_checkpoint/helpers/dialog_helper.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return WelcomeScreenState();
  }
}

class WelcomeScreenState extends State<WelcomeScreen>
    with WidgetsBindingObserver {
  // A list of required permissions to be accepted in order for app to properly run
  List<Permission> _requiredPermissions = [
    Permission.phone,
    Permission.location,
    Permission.camera
  ];

  // A flag to determined if app was navigated away (background) using openAppSettings()
  bool _isFromAppSettings = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _checkRequiredPermissions();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    // Will be called when app is in foreground & if it triggered the background activity using openAppSettings()
    if (state == AppLifecycleState.resumed && _isFromAppSettings) {
      _isFromAppSettings = false;
      _checkRequiredPermissions();
    }
  }

  @override
  Widget build(BuildContext context) {
    final UserLocation locationServiceProvider =
        Provider.of<UserLocation>(context);

    return Theme(
      data: Purple.buildFor(context),
      child: Scaffold(
        backgroundColor: deepPurple600,
        body: Container(
          margin: const EdgeInsets.symmetric(vertical: 40.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // Sample implementation of the GPS Location
                // Center(
                //   child: Text(
                //       'Location: Lat${locationServiceProvider?.latitude}, Long: ${locationServiceProvider?.longitude}'),
                // ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: InkWell(
                    onDoubleTap: () =>
                        Navigator.of(context).push(CreditsScreen()),
                    borderRadius: BorderRadius.circular(100),
                    child: SvgPicture.asset(
                      RapidAssetConstants.rapidPassLogo,
                    ),
                  ),
                ),
                Text('Welcome to',
                    style: TextStyle(fontSize: 27.0),
                    textAlign: TextAlign.center),
                Text('RapidPass.ph\nCheckpoint',
                    softWrap: true,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 32.0),
                    textAlign: TextAlign.center),
                Padding(
                  padding: EdgeInsets.only(top: 28),
                  child: Text(
                    "Database updated as of\nMarch 29, 2020",
                    textAlign: TextAlign.center,
                  ),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SizedBox(
                    height: 48,
                    width: 300.0,
                    child: RaisedButton(
                      shape: new RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.0)),
                      onPressed: () {
                        Navigator.pushNamed(context, "/menu");
                      },
                      child: Text("Start",
                          style: TextStyle(
                              // Not sure how to get rid of color: Colors.white here
                              color: Colors.white,
                              fontSize: 18.0)),
                    ),
                  ),
                ),
                Selector<DeviceInfoModel, String>(
                  selector: (_, model) => model.imei,
                  builder: (_, String imei, __) {
                    if (imei == null) return Text('Retrieving IMEI...');
                    return Text('IMEI: $imei');
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _checkRequiredPermissions() async {
    final Map<Permission, PermissionStatus> permissions =
        await _requiredPermissions.request();
    debugPrint('permissions => $permissions');

    bool isDeniedPermanently = permissions.values
        .any((PermissionStatus status) => status.isPermanentlyDenied);
    if (isDeniedPermanently) return _onPermissionDeniedPermanently();

    bool isAllGranted =
        permissions.values.every((PermissionStatus status) => status.isGranted);
    if (!isAllGranted) return _onPermissionDenied();

    _onAllPermissionGranted();
  }

  void _onAllPermissionGranted() {
    Provider.of<DeviceInfoModel>(context, listen: false).getImei();
  }

  void _onPermissionDeniedPermanently() {
    DialogHelper.showAlertDialog(context,
        title: 'Some permission was denied permanently',
        message:
            'In order for the app to run properly, you must tap OPEN SETTINGS and grant the CAMERA, LOCATION, and PHONE permission.',
        dismissible: false,
        onWillPop: () async => false,
        cancelText: 'EXIT APP',
        onCancel: () => SystemNavigator.pop(),
        confirmText: 'OPEN SETTINGS',
        onConfirm: () {
          _isFromAppSettings = true;
          openAppSettings();
        });
  }

  void _onPermissionDenied() {
    DialogHelper.showAlertDialog(
      context,
      title: 'Some permission was denied',
      message:
          'In order for the app to run properly, we need you to allow all permissions requested.',
      dismissible: false,
      onWillPop: () async => false,
      cancelText: 'EXIT APP',
      onCancel: () => SystemNavigator.pop(),
      confirmText: 'ALLOW PERMISSIONS',
      onConfirm: () => _checkRequiredPermissions(),
    );
  }
}
