import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rapidpass_checkpoint/themes/default.dart';
import 'package:rapidpass_checkpoint/utils/qr_code_decoder.dart';

class PassOkScreen extends StatelessWidget {
  QrData qrData;

  PassOkScreen(this.qrData);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: green300,
        appBar: AppBar(backgroundColor: Colors.green.shade900, title: Text('Pass Ok')),
        body: Container(
            margin: const EdgeInsets.symmetric(vertical: 48.0),
            child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[Text('Pass Ok')]))));
  }
}
