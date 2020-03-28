import 'package:flutter/material.dart';
import 'package:rapidpass_checkpoint/components/pass_results_card.dart';
import 'package:rapidpass_checkpoint/models/qr_data.dart';
import 'package:rapidpass_checkpoint/themes/default.dart';

const borderRadius = 12.0;

class PassInvalidScreen extends StatelessWidget {
  QrData qrData;

  PassInvalidScreen(this.qrData);

  @override
  Widget build(BuildContext context) {
    // TODO ValidatorService
    final tableData = {
      'Control Code': '${qrData.controlCodeAsString()}',
      'Plate Number:': qrData.idOrPlate,
      'Access Type:': qrData.purpose(),
      'Valid From:': qrData.validFromDisplayDate(),
      'Valid Until:': qrData.validUntilDisplayDate(),
    };
    final passResultsData = tableData.entries.map((e) {
      return e.key == 'Valid Until:'
          ? PassResultsData(
              label: e.key,
              value: e.value,
              errorMessage:
                  'Pass is only valid until ${qrData.validUntilDisplayTimestamp()}')
          : PassResultsData(label: e.key, value: e.value);
    }).toList();
    return Theme(
      data: Green.buildFor(context),
      child: Scaffold(
          appBar: AppBar(title: Text('Result')),
          body: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    PassResultsCard(
                        iconName: 'error',
                        headerText: 'PASS EXPIRED',
                        data: passResultsData,
                        color: Colors.red),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      child: SizedBox(
                        height: 48,
                        width: 300.0,
                        child: RaisedButton(
                          shape: new RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24.0)),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Scan another QR code',
                              style: TextStyle(
                                  // Not sure how to get rid of color: Colors.white here
                                  color: Colors.white,
                                  fontSize: 16.0)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      child: SizedBox(
                        height: 48,
                        child: FlatButton(
                          shape: new RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24.0),
                              side: BorderSide(color: green300)),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Return to checker page',
                              style: TextStyle(
                                  // Not sure how to get rid of color: Colors.white here
                                  color: green300,
                                  fontSize: 16.0)),
                        ),
                      ),
                    )
                  ],
                ),
              ))),
    );
  }
}