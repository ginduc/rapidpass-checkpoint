import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rapidpass_checkpoint/themes/default.dart';
import 'package:rapidpass_checkpoint/utils/base32_crockford.dart';
import 'package:rapidpass_checkpoint/utils/qr_code_decoder.dart';
import 'package:rapidpass_checkpoint/models/qr_data.dart';

import '../themes/default.dart';

class Result extends StatelessWidget {
  final QrData qrData;
  final Map tableData;
  final Color headerColor;
  final String headerIcon;
  final String headerText;
  final String headerSubtext;
  Result(this.qrData, this.tableData, this.headerColor, this.headerIcon,
      this.headerText, this.headerSubtext);

  @override
  Widget build(BuildContext context) {
    final tableTextStyle = TextStyle(fontSize: 20.0);

    return Scaffold(
        appBar: AppBar(title: Text('Result')),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(children: <Widget>[
            Container(
                decoration: BoxDecoration(
                    border: Border.all(color: headerColor, width: 1.0),
                    borderRadius: BorderRadius.circular(8.0)),
                margin: const EdgeInsets.symmetric(vertical: 48.0),
                child: Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                      Container(
                        color: headerColor,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Center(
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Image(
                                    width: 80.0,
                                    image: AssetImage(headerIcon),
                                  ),
                                ),
                                Text(
                                  headerText,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  headerSubtext,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 19.0,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Table(
                              children: tableData.entries.map((e) {
                            return TableRow(children: [
                              Text(
                                e.key,
                                style: tableTextStyle,
                              ),
                              Text(
                                e.value,
                                textAlign: TextAlign.right,
                                style: tableTextStyle.copyWith(
                                    fontWeight: FontWeight.bold),
                              )
                            ]);
                          }).toList())),
                    ]))),
            ButtonTheme(
              minWidth: 315,
              child: RaisedButton(
                color: green300,
                shape: new RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.0)),
                onPressed: () {},
                child: Text('Scan another Qr',
                    style: TextStyle(
                        // Not sure how to get rid of color: Colors.white here
                        color: Colors.white,
                        fontSize: 18.0)),
              ),
            ),
            ButtonTheme(
              minWidth: 315,
              child: RaisedButton(
                color: Colors.white,
                shape: new RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.0)),
                onPressed: () {},
                child: Text('Return to checker page',
                    style: TextStyle(
                        // Not sure how to get rid of color: Colors.white here
                        color: green300,
                        fontSize: 18.0)),
              ),
            ),
          ]),
        ));
  }
}
