import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rapidpass_checkpoint/themes/default.dart';
import 'package:rapidpass_checkpoint/utils/qr_code_decoder.dart';

class PassOkScreen extends StatelessWidget {
  QrData qrData;

  PassOkScreen(this.qrData);

  @override
  Widget build(BuildContext context) {
    final tableTextStyle = TextStyle(fontSize: 20.0);
    final tableData = {
      'Control Code': '2A8B043',
      'Plate Number:': 'ABC 1234',
      'Access Type:': 'Medical (M)',
      'Valid From:': 'March 23, 2020',
      'Valid Until:': 'March 27, 2020',
    };
    return Scaffold(
        appBar: AppBar(title: Text('Result')),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: green300, width: 1.0),
                  borderRadius: BorderRadius.circular(8.0)),
              margin: const EdgeInsets.symmetric(vertical: 48.0),
              child: Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                    Container(
                      color: green300,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Center(
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Image(
                                  width: 80.0,
                                  image: AssetImage('assets/check-2x.png'),
                                ),
                              ),
                              Text(
                                'ENTRY APPROVED',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22.0,
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
                            children: tableData.entries
                                .map((e) => TableRow(children: [
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
                                    ]))
                                .toList())),
                  ]))),
        ));
  }
}
