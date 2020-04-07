import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:rapidpass_checkpoint/components/pass_results_card.dart';
import 'package:rapidpass_checkpoint/models/apor.dart';
import 'package:rapidpass_checkpoint/models/check_plate_or_control_args.dart';
import 'package:rapidpass_checkpoint/models/qr_data.dart';
import 'package:rapidpass_checkpoint/models/scan_results.dart';
import 'package:rapidpass_checkpoint/themes/default.dart';

const borderRadius = 12.0;

/// Pass or Fail screen
class CheckPlateOrControlCodeResultsScreen extends StatelessWidget {
  final CheckPlateOrControlScreenModeType screenModeType;

  final ScanResults scanResults;

  CheckPlateOrControlCodeResultsScreen(CheckPlateOrControlScreenResults args)
      : this.screenModeType = args.screenModeType,
        this.scanResults = args.scanResults {
    if (scanResults.isValid()) {
      playNotificationApproved();
    } else {
      playNotificationRejected();
    }
  }

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

      if (label == 'Plate Number' && tableData[RapidPassField.passType].startsWith("I -")) {
        return null;
      }

      return error == null
          ? PassResultsTableRow(label: label, value: value)
          : PassResultsTableRow(
              label: label, value: value, errorMessage: errorMessage);
    }).toList();
    passResultsData.removeWhere((field) => field == null);

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
          body: SingleChildScrollView(
              child: Center(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10.0),
                  child: card,
                ),
                const SizedBox(height: 5),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
//                    if (scanResults.isValid() == true)
//                      InkWell(
//                        onTap: () =>
//                            Navigator.pushNamed(context, '/viewMoreInfo'),
//                        child: Container(
//                          padding: EdgeInsets.symmetric(
//                              vertical: 13.0, horizontal: 20.0),
//                          child: OutlineButton(
//                            borderSide: BorderSide(color: green300),
//                            highlightedBorderColor: green300,
//                            focusColor: green300,
//                            child: Text('View More Information',
//                                style: TextStyle(fontSize: 16)),
//                            shape: RoundedRectangleBorder(
//                              borderRadius: BorderRadius.circular(30.0),
//                            ),
//                            color: green300,
//                            textColor: green300,
//                            padding: EdgeInsets.symmetric(
//                              horizontal: 16.0,
//                              vertical: 20.0,
//                            ),
//                            onPressed: () =>
//                                Navigator.pushNamed(context, '/viewMoreInfo'),
//                          ),
//                        ),
//                      ),
                    if (scanResults.isValid() == true)
                      Padding(padding: EdgeInsets.only(top: 16.0)),
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 20.0),
                        child: RaisedButton(
                          child: Text(
                              this.screenModeType ==
                                      CheckPlateOrControlScreenModeType.plate
                                  ? 'Check another Plate Number'
                                  : 'Check another Control Number',
                              style: TextStyle(fontSize: 16)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(34.0),
                          ),
                          color: green300,
                          textColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 20.0),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => Navigator.popUntil(
                          context, ModalRoute.withName('/menu')),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 20.0),
                        child: OutlineButton(
                          borderSide: BorderSide(color: green300),
                          focusColor: green300,
                          child: Text('Return to checker page',
                              style: TextStyle(fontSize: 16)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          color: green300,
                          textColor: green300,
                          highlightedBorderColor: green300,
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 20.0),
                          onPressed: () => Navigator.popUntil(
                              context, ModalRoute.withName('/menu')),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30)
                  ],
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

  Future<AudioPlayer> playNotificationRejected() async {
    AudioCache cache = new AudioCache();
    return await cache.play("notification_denied.mp3");
  }
}
