import 'package:flutter/material.dart';
import 'package:ai_barcode/ai_barcode.dart';
import 'package:flutter/cupertino.dart';

class QrScannerScreenArgs {
  /// Appbar's title text
  final String title;

  /// Guide message for the QrScanner
  final String message;

  /// Duration on when the message will be hidden
  final Duration duration;

  const QrScannerScreenArgs(
      {this.title = 'Scan QR Code',
      this.message,
      this.duration = const Duration(seconds: 3)});
}

class QrScannerScreen extends StatefulWidget {
  final QrScannerScreenArgs args;
  const QrScannerScreen(this.args);

  @override
  _QrScannerScreenState createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen>
    with WidgetsBindingObserver {
  ScannerController _scannerController;
  bool _isFlashOn = false;
  bool _isMessageShown = true;
  bool _isInteractive = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _scannerController = ScannerController(
        scannerResult: (String data) => Navigator.pop(context, data));

    // Need to add the delay
    Future.delayed(const Duration(milliseconds: 250), () {
      _scannerController.startCamera();
      _scannerController.startCameraPreview();

      if (!mounted) return;
      setState(() => _isInteractive = true);
    });

    if (widget.args?.message != null) {
      Future.delayed(widget.args.duration, () {
        if (!mounted) return;
        setState(() => _isMessageShown = false);
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      _scannerController.startCameraPreview();
    } else if (state == AppLifecycleState.paused) {
      _scannerController.stopCameraPreview();
    }
  }

  @override
  void dispose() {
    _scannerController.stopCameraPreview();
    _scannerController.stopCamera();
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.args?.title),
        ),
        body: Stack(
          children: <Widget>[
            Container(
                color: Colors.black,
                child: PlatformAiBarcodeScannerWidget(
                  platformScannerController: _scannerController,
                )),
            if (widget.args?.message != null)
              Positioned(
                left: 44,
                right: 44,
                bottom: 108,
                child: AnimatedOpacity(
                    opacity: _isMessageShown ? 1 : 0,
                    duration: const Duration(milliseconds: 400),
                    child: _buildMessage()),
              ),
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child:
                    Material(color: Colors.black26, child: _buildFlashButton()))
          ],
        ));
  }

  Widget _buildMessage() {
    return Container(
      decoration: BoxDecoration(
          color: const Color(0xFFC4C4C4),
          borderRadius: BorderRadius.circular(5.0)),
      padding: const EdgeInsets.all(12.0),
      child: Text(widget.args.message, textAlign: TextAlign.center),
    );
  }

  Widget _buildFlashButton() {
    return IconButton(
        padding: const EdgeInsets.all(36.0),
        icon: Icon(_isFlashOn ? Icons.flash_off : Icons.flash_on,
            color: Colors.white),
        onPressed: _isInteractive ? _onToggleFlash : null);
  }

  void _onToggleFlash() {
    if (_scannerController.isStartCamera) {
      _scannerController.toggleFlash();
      _scannerController.startCameraPreview();

      if (!mounted) return;
      setState(() => _isFlashOn = !_isFlashOn);
    }
  }
}
