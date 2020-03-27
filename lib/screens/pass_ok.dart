import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rapidpass_checkpoint/models/qr_data.dart';
import 'package:rapidpass_checkpoint/screens/main_menu.dart';
import 'package:rapidpass_checkpoint/themes/default.dart';

/// TODO: Come up with a better name
class BoxWithRoundedBordersAndFilledHeader extends StatelessWidget {
  final Widget header;
  final Widget body;
  final Color color;
  BoxWithRoundedBordersAndFilledHeader(
      {Widget header, Widget body, Color color})
      : this.header = header ?? Container(),
        this.body = body ?? Container(),
        this.color = color ?? green300;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            border: Border.all(color: this.color, width: 1.0),
            borderRadius: BorderRadius.circular(8.0)),
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
              Container(
                color: green300,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: this.header,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: this.body,
              )
            ])));
  }
}

class PassOkScreen extends StatelessWidget {
  QrData qrData;

  PassOkScreen(this.qrData);

  @override
  Widget build(BuildContext context) {
    final tableTextStyle = TextStyle(fontSize: 18.0);
    final tableData = {
      'Control Code': '${qrData.controlCodeAsString()}',
      'Plate Number:': qrData.idOrPlate,
      'Access Type:': qrData.purpose(),
      'Valid From:': qrData.validFromDisplayDate(),
      'Valid Until:': qrData.validUntilDisplayDate(),
    };
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
                    BoxWithRoundedBordersAndFilledHeader(
                      header: Column(
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
                      body: Padding(
                          padding: const EdgeInsets.all(10.0),
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
                    ),
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
                            MainMenu().scan(context);
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
                            Navigator.popAndPushNamed(context, "/menu");
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
