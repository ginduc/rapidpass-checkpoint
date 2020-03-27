import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rapidpass_checkpoint/components/main_menu_button.dart';
import 'package:rapidpass_checkpoint/themes/default.dart';
import 'package:rapidpass_checkpoint/utils/qr_code_decoder.dart';

class MainMenuScreen extends StatelessWidget {
  final String checkPointName;
  final bool openScan;

  MainMenuScreen({Key key, this.checkPointName, this.openScan}) : super(key: key);
  //(this.checkPointName, this.openScan);

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
              MainMenu(this.openScan),
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

  final bool openScan;

  MainMenu(this.openScan);

  @override
  Widget build(BuildContext context) {

    if(this.openScan == true){
       scan(context);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          MainMenuButton(
              'Scan QR Code', 'icons8_qr-code-2x.png', () => scan(context)),
          MainMenuButton('Plate Number', 'license-plate-2x.png', () {
            debugPrint('Plate Number pressed');
            Navigator.pushNamed(context, '/checkPlateNumber');
          }),
          MainMenuButton('Control Code', 'control_number-2x.png', () {
            debugPrint('Control Code pressed');
            Navigator.pushNamed(context, '/checkControlCode');
          }),
        ],
      ),
    );
  }

  Future scan(BuildContext context) async {
    try {
      final String base64Encoded = await BarcodeScanner.scan();
      final decoded = base64.decode(base64Encoded);
      final asHex = decoded.map((i) => i.toRadixString(16));
      debugPrint('barcode => $asHex (${asHex.length} codes)');
      final buffer = decoded is Uint8List
          ? decoded.buffer
          : Uint8List.fromList(decoded).buffer;
      final byteData = ByteData.view(buffer);
      final rawQrData = QrCodeDecoder().convert(byteData);
      Navigator.pushNamed(context, "/passOk", arguments: rawQrData);
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

  void _showDialog(BuildContext context, {String title, String body}) {
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
