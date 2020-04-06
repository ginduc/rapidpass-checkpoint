import 'package:flutter/material.dart';
import 'package:qrcode/qrcode.dart';

class MasterQrScannerScreen extends StatefulWidget {
  @override
  _MasterQrScannerScreenState createState() => _MasterQrScannerScreenState();
}

class _MasterQrScannerScreenState extends State<MasterQrScannerScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  QRCaptureController _captureController = QRCaptureController();

  bool _isTorchOn = false;
  String _captureText = '';
  bool scanned = false;

  @override
  void initState() {
    super.initState();

    _captureController.onCapture((data) {
      if (scanned == false) validate(data);
    });
  }

  @override
  void dispose() {
    _captureController.pause();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Master QR Code'),
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Container(
                    width: 400,
                    height: 400,
                    child: QRCaptureView(
                      controller: _captureController,
                    ),
                  ),
                  Container(
                    child: Text(_captureText),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 24.0, left: 10.0),
                child: Text(
                  'Position the QR image inside the frame.\nIt will scan automatically.',
                  textAlign: TextAlign.center,
                ),
              ),
              FlatButton(
                onPressed: () {
                  debugPrint('_isTorchOn: $_isTorchOn');
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
            ]),
      ),
    );
  }

  void validate(code) {
    try {
      this.scanned = true;
      _captureController.pause();
      debugPrint('code: $code');
      Navigator.pop(context, code);
    } catch (e) {
      debugPrint('Error occured: $e');
    }
    return null;
  }
}
