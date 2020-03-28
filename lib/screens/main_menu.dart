import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rapidpass_checkpoint/common/constants/rapid_asset_constants.dart';
import 'package:rapidpass_checkpoint/models/qr_data.dart';
import 'package:rapidpass_checkpoint/models/scan_results.dart';
import 'package:rapidpass_checkpoint/themes/default.dart';
import 'package:rapidpass_checkpoint/utils/qr_code_decoder.dart';
import 'package:rapidpass_checkpoint/widgets/rapid_main_menu_button.dart';

class MainMenuScreen extends StatelessWidget {
  final String checkPointName;

  MainMenuScreen(this.checkPointName);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('RapidPass Checkpoint')),
      body: Container(
        margin: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CheckPointWidget(this.checkPointName),
              MainMenu(),
            ],
          ),
        ),
      ),
    );
  }
}

class CheckPointWidget extends StatelessWidget {
  final String checkPointName;

  CheckPointWidget(this.checkPointName);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'RapidPass Checkpoint:',
            textAlign: TextAlign.left,
            style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: deepPurple600),
          ),
        ),
        Container(
          width: 320.0,
          height: 50.0,
          decoration: BoxDecoration(color: deepPurple600),
          child: Center(
            child: Text(
              this.checkPointName,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}

class MainMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            "CHECK VIA:",
            style: Theme.of(context)
                .textTheme
                .body1
                .copyWith(fontWeight: FontWeight.bold),
          ),
          RapidMainMenuButton(
            title: 'Scan QR Code',
            iconPath: RapidAssetConstants.icQrCode,
            onPressed: () => _scanAndNavigate(context),
          ),
          RapidMainMenuButton(
            title: 'Plate Number',
            iconPath: RapidAssetConstants.icPlateNubmer,
            onPressed: () {
              final hex = 'd6948580835e77fc005e7d42000e41424331323334893c6f13';
              final bytes = QrCodeDecoder.decodeHex(hex);
              final input = String.fromCharCodes(bytes);
              final list = input.codeUnits;
              final buffer = list is Uint8List
                  ? list.buffer
                  : Uint8List.fromList(list).buffer;
              final byteData = ByteData.view(buffer);
              final qrData = QrCodeDecoder().convert(byteData);
              final scanResults = ScanResults(qrData);
              scanResults.errors.add(ValidationError(
                  'Pass was valid only until ${qrData.validUntilDisplayTimestamp()}',
                  source: 'Valid Until:'));
              Navigator.pushNamed(context, "/passInvalid",
                  arguments: scanResults);
            },
          ),
          RapidMainMenuButton(
            title: 'Control Code',
            iconPath: RapidAssetConstants.icControlCode,
            onPressed: () {
              Navigator.pushNamed(context, '/checkControlCode');
            },
          ),
        ],
      ),
    );
  }

  Future _scanAndNavigate(final BuildContext context) async {
    final qrData = await scan(context);
    final scanResults = ScanResults(qrData);
    // TODO: Use ValidatorService
    Navigator.pushNamed(context, '/passOk', arguments: scanResults);
  }

  // TODO: Maybe move this to a service or something
  static Future<QrData> scan(final BuildContext context) async {
    try {
      final String base64Encoded = await BarcodeScanner.scan();
      final decoded = base64.decode(base64Encoded);
      final asHex = decoded.map((i) => i.toRadixString(16));
      debugPrint('barcode => $asHex (${asHex.length} codes)');
      final buffer = decoded is Uint8List
          ? decoded.buffer
          : Uint8List.fromList(decoded).buffer;
      final byteData = ByteData.view(buffer);
      return QrCodeDecoder().convert(byteData);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        _showDialog(context, title: 'Error', body: 'Camera access denied');
      } else {
        _showDialog(context, title: 'Error', body: 'Unknown Error');
      }
    } on FormatException {
      debugPrint(
          'null (User returned using the "back"-button before scanning anything. Result)');
      _showDialog(context,
          title: 'Error',
          body:
              'User returned using the "back"-button before scanning anything. Result');
    } catch (e) {
      _showDialog(context, title: 'Error', body: 'Unknown Error: $e');
    }
  }

  static void _showDialog(BuildContext context, {String title, String body}) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(title),
          content: new Text(body),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
