import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:rapidpass_checkpoint/components/pass_results_card.dart';
import 'package:rapidpass_checkpoint/models/apor.dart';
import 'package:rapidpass_checkpoint/models/qr_data.dart';
import 'package:rapidpass_checkpoint/models/scan_results.dart';
import 'package:rapidpass_checkpoint/screens/main_menu.dart';
import 'package:rapidpass_checkpoint/themes/default.dart';

const borderRadius = 12.0;

/// Pass or Fail screen
class CheckPlateOrControlCodeResultsScreen extends StatelessWidget {
  ScanResults scanResults;

  CheckPlateOrControlCodeResultsScreen(this.scanResults);

  @override
  Widget build(BuildContext context) {
    final qrData = scanResults.qrData;
    final tableData = qrData != null
        ? {
            RapidPassField.passType: (qrData.passType == PassType.Vehicle)
                ? "V - Vehicle"
                : "I - Individual",
            RapidPassField.controlCode: '${qrData.controlCodeAsString()}',
            RapidPassField.idOrPlate: qrData.idOrPlate,
            RapidPassField.apor: qrData.purpose(),
            RapidPassField.validFrom: qrData.validFromDisplayDate(),
            RapidPassField.validUntil: qrData.validUntilDisplayDate(),
          }
        : {
            RapidPassField.passType: '',
            RapidPassField.controlCode: '',
            RapidPassField.idOrPlate: '',
            RapidPassField.apor: '',
            RapidPassField.validFrom: '',
            RapidPassField.validUntil: '',
          };
    final passResultsData = tableData.entries.map((e) {
      var field = e.key;
      final String label = field == RapidPassField.idOrPlate
          ? 'Plate Number'
          : getFieldName(field);

      String errorMessage;
      final error = scanResults.findErrorForSource(field);
      if (error != null) {
        errorMessage = error.errorMessage;
      }
      final value =
          field == RapidPassField.apor && aporCodes.containsKey(e.value)
              ? aporCodes[e.value] + ' (${e.value})'
              : e.value;

      return error == null
          ? PassResultsTableRow(label: label, value: value)
          : PassResultsTableRow(
              label: label, value: value, errorMessage: errorMessage);
    }).toList();

    if (scanResults.isValid()) {
      playNotificationApproved();
    } else {
      playNotificationRegected();
    }

    final card = scanResults.isValid()
        ? PassResultsCard(
            iconName: 'check-2x',
            headerText: scanResults.resultMessage,
            data: passResultsData,
            color: green300)
        : PassResultsCard(
            iconName: 'error',
            headerText: scanResults.resultMessage,
            data: passResultsData,
            color: Colors.red,
            allRed: scanResults.allRed,
          );
    return Theme(
      data: Green.buildFor(context),
      child: Scaffold(
          appBar: AppBar(title: Text('Result')),
          body: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Center(
                child: ListView(
                  children: <Widget>[
                    card,
                    if (scanResults.isValid() == true)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 20.0),
                        child: SizedBox(
                          height: 58,
                          width: 300.0,
                          child: RaisedButton(
                            shape: new RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(34.0)),
                            onPressed: () =>
                                Navigator.pushNamed(context, "/viewMoreInfo"),
                            child: Text('View more info',
                                style: TextStyle(
                                    // Not sure how to get rid of color: Colors.white here
                                    color: Colors.white,
                                    fontSize: 16.0)),
                          ),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 20.0,
                      ),
                      child: SizedBox(
                        height: 58,
                        child: FlatButton(
                          color: green300,
                          shape: new RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(34.0),
                            side: BorderSide(color: green300)
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Check another Plate Number',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 20.0),
                      child: SizedBox(
                        height: 58,
                        child: FlatButton(
                          shape: new RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(34.0),
                              side: BorderSide(color: green300)),
                          onPressed: () {
                            Navigator.popUntil(
                                context, ModalRoute.withName('/menu'));
                          },
                          child: Text('Return to checker page',
                              style: TextStyle(
                                  // Not sure how to get rid of color: Colors.white here
                                  color: green300,
                                  fontSize: 16.0)),
                        ),
                      ),
                    ),
                  ],
                ),
              ))),
    );
  }

  Future<AudioPlayer> playNotificationApproved() async {
    AudioCache cache = new AudioCache();
    return await cache.play("notification_approved.mp3");
  }

  Future<AudioPlayer> playNotificationRegected() async {
    AudioCache cache = new AudioCache();
    return await cache.play("notification_denied.mp3");
  }
}
