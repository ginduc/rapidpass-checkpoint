import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_code_scanner/qr_scanner_overlay_shape.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rapidpass_checkpoint/helpers/dialog_helper.dart';

class QrScannerScreen extends StatefulWidget {
  @override
  _QrScannerScreenState createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen>
    with WidgetsBindingObserver {
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController _controller;

  // A flag to determined if app was navigated away (background) using openAppSettings()
  bool _isFromAppSettings = false;
  bool _isCameraAvailable = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _checkPermission();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    // Will be called when app is in foreground & if it triggered the background activity using openAppSettings()
    if (state == AppLifecycleState.resumed && _isFromAppSettings) {
      _isFromAppSettings = false;
      _checkPermission();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text("Scan QR Code"),
      ),
      body: !_isCameraAvailable
          ? SizedBox()
          : QRView(
              key: _qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                  borderColor: Colors.white,
                  borderLength: 56,
                  borderWidth: 8,
                  cutOutSize: 260),
            ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this._controller = controller;

    this._controller.scannedDataStream.listen((String data) {
      this._controller.pauseCamera();
      Navigator.pop(context, data);
    });
  }

  void _checkPermission() async {
    if (await Permission.camera.isPermanentlyDenied && Platform.isAndroid) {
      _onCameraDeniedPermanently();
    } else if (await Permission.camera.isUndetermined ||
        await Permission.camera.isDenied) {
      _requestPermission();
    } else {
      _onCameraGranted();
    }
  }

  void _requestPermission() async {
    final PermissionStatus status = await Permission.camera.request();
    if (status == PermissionStatus.denied) {
      _onCameraDenied();
    } else if (status == PermissionStatus.permanentlyDenied) {
      _onCameraDeniedPermanently();
    } else {
      _onCameraGranted();
    }
  }

  void _onCameraGranted() {
    setState(() => _isCameraAvailable = true);
  }

  void _onCameraDeniedPermanently() {
    DialogHelper.showAlertDialog(context,
        title: 'Camera access denied permanently',
        message:
            'To use this feature, you must OPEN SETTINGS and grant the CAMERA permission.',
        confirmText: 'OPEN SETTINGS',
        onWillPop: () async => Navigator.pop(context),
        onCancel: () => Navigator.pop(context),
        onConfirm: () {
          _isFromAppSettings = true;
          openAppSettings();
        });
  }

  void _onCameraDenied() {
    DialogHelper.showAlertDialog(
      context,
      title: 'Camera access denied',
      message: 'We need to access your camera to use this feature.',
      confirmText: 'REQUEST ACCESS',
      onWillPop: () async => Navigator.pop(context),
      onConfirm: () => _requestPermission(),
      onCancel: () => Navigator.pop(context),
    );
  }
}
