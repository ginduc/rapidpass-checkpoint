import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:rapidpass_checkpoint/common/constants/rapid_asset_constants.dart';
import 'package:rapidpass_checkpoint/helpers/dialog_helper.dart';
import 'package:rapidpass_checkpoint/models/app_state.dart';
import 'package:rapidpass_checkpoint/repository/api_repository.dart';
import 'package:rapidpass_checkpoint/screens/credits_screen.dart';
import 'package:rapidpass_checkpoint/themes/default.dart';
import 'package:rapidpass_checkpoint/viewmodel/device_info_model.dart';

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
    return Theme(
      data: Purple.buildFor(context),
      child: Scaffold(
        backgroundColor: deepPurple600,
        body: Container(
          margin: const EdgeInsets.only(top: 50.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
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
                  child:
                      Consumer<AppState>(builder: (context, appState, child) {
                    return Text(
                      appState.databaseLastUpdatedText ??
                          'Please sync the database',
                      style: TextStyle(fontSize: 18.0),
                    );
                  }),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: SizedBox(
                          height: 48,
                          width: 300.0,
                          child: Consumer<ApiRepository>(
                            builder: (_, apiRepository, __) => RaisedButton(
                              shape: new RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24.0)),
                              // only enable the 'Start' button once we have an ApiRepository
                              onPressed: apiRepository != null
                                  ? () => _startButtonPressed(context)
                                  : null,
                              child: Text('Start',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18.0)),
                            ),
                          ),
                        ),
                      ),
                      Selector<DeviceInfoModel, String>(
                        selector: (_, model) => model.imei,
                        builder: (_, String imei, __) {
                          if (imei == null) return Text('Retrieving IMEI...');
                          return Text('IMEI: $imei');
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 80,
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.05),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      _buildFooter('About'),
                      _buildFooter('FAQs'),
                      _buildFooter('Contact Us'),
                      _buildFooter('Privacy Policy'),
                      IconButton(
                        icon: Icon(
                          Icons.settings,
                          color: Colors.white70,
                        ),
                        onPressed: () =>
                            Navigator.pushNamed(context, '/settings'),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _startButtonPressed(final BuildContext context) async {
    final AppState appState = Provider.of<AppState>(context, listen: false);
    debugPrint('_startButtonPressed()');
    if (appState.masterQrCode == null) {
      Navigator.pushNamed(context, '/masterQrScannerScreen').then((code) {
        debugPrint("masterQrScannerScreen returned $code");
        appState.masterQrCode = code;
        Navigator.pushNamed(context, '/authenticatingScreen');
      });
    } else {
      Navigator.pushNamed(context, '/authenticatingScreen');
    }
  }

  Widget _buildFooter(String title) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
          context, "/${title.replaceAll(' ', '_').toLowerCase()}"),
      child: Text(
        title,
        style: TextStyle(
            color: Colors.white70,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.0,
            decoration: TextDecoration.underline),
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
