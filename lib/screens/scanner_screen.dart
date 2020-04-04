
import 'package:qrcode/qrcode.dart';
import 'package:flutter/material.dart';
import 'package:rapidpass_checkpoint/models/scan_results.dart';
import 'dart:io' show Platform;

import 'package:rapidpass_checkpoint/services/pass_validation_service.dart';

class ScannerScreen extends StatefulWidget {
  @override
  _ScannerScreenState createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> with TickerProviderStateMixin, WidgetsBindingObserver {
  QRCaptureController _captureController = QRCaptureController();

  bool _isTorchOn = false;
  String _captureText = '';
  bool scanned = false;

  @override
  void initState() {
    super.initState();

    _captureController.onCapture((data) {
      if(scanned == false)
        validate(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Scan QR Code'),
        ),
        body: Column(
           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
           crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Container(
                    width: 300,
                     height: 300,
                    child: QRCaptureView(
                    controller: _captureController,
                  ),
                ),
                Container(
                  child: Text('$_captureText'),
                )
              ],
            ),
             Padding(
              padding: EdgeInsets.only(top: 24.0, left: 10.0),
              child: Text("Position the QR image inside the frame. It will scan automatically."),
            ),
             FlatButton(
              onPressed: () {
                if (_isTorchOn) {
                  _captureController.torchMode = CaptureTorchMode.off;
                } else {
                  _captureController.torchMode = CaptureTorchMode.on;
                }
                _isTorchOn = !_isTorchOn;
              },
              child: Text(
                      "Flash",
                      style: Theme.of(context).textTheme.title.copyWith(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ]
      ),
    );
  }

  void validate(code) {
    try {
      final String base64Encoded = code;
      this.scanned = true;
      if (base64Encoded != null) {
         final scanResults = PassValidationService.deserializeAndValidate(base64Encoded);

         if (scanResults is ScanResults) {
          Navigator.pushNamed(context, '/scanResults', arguments: scanResults);
          // this.scanned = false;
        }
      }
      
    } catch (e) {
      debugPrint('Error occured: $e');
    }
    return null;
  }



}