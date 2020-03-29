import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:rapidpass_checkpoint/components/pass_results_card.dart';
import 'package:rapidpass_checkpoint/models/scan_results.dart';
import 'package:rapidpass_checkpoint/screens/main_menu.dart';
import 'package:rapidpass_checkpoint/themes/default.dart';

const borderRadius = 12.0;

const aporCodes = {
  'AG': 'Agribusiness & Agricultural Workers',
  'BA': 'Banks',
  'BP': 'BPOs & Export-Oriented Business Personnel',
  'CA': 'Civil Aviation',
  'DC': 'Delivery personnel of cargoes',
  'DO': 'Distressed OFWs',
  'ER': 'Emergency Responders',
  'FC': 'Food Chain/ Resturants',
  'FS': 'Funeral Service',
  'GO': 'Government Agency',
  'GR': 'Grocery / Convenience Stores',
  'HM': 'Heads of Mission',
  'HT': 'Hotel Employees and Tenants',
  'IP': 'International Passengers and Driver',
  'LW': 'Logistics Warehouse',
  'ME': 'Media Personalities',
  'MS': 'Medical Services',
  'MF': 'Manufacturing',
  'MT': 'Money Transfer Services',
  'PH': 'Pharmacies / Drug Stores',
  'PM': 'Public Market',
  'PI': 'Private Individual',
  'SH': 'Ship Captain & Crew',
  'SS': 'Security Services',
  'TF': 'Transportation Facilities',
  'UT': 'Utilities',
  'VE': 'Veterinary'
};

/// Pass or Fail screen
class ScanResultScreen extends StatelessWidget {
  ScanResults scanResults;

  ScanResultScreen(this.scanResults);

  @override
  Widget build(BuildContext context) {
    final qrData = scanResults.qrData;
    final tableData = {
      RapidPassField.passType:
          qrData.passType == 0x80 ? "V - Vehicle" : "I - Individual",
      RapidPassField.controlCode: '${qrData.controlCodeAsString()}',
      RapidPassField.idOrPlate: qrData.idOrPlate,
      RapidPassField.apor: qrData.purpose(),
      RapidPassField.validFrom: qrData.validFromDisplayDate(),
      RapidPassField.validUntil: qrData.validUntilDisplayDate(),
    };
    final passResultsData = tableData.entries.map((e) {
      var field = e.key;
      final String label = field == RapidPassField.idOrPlate
          ? 'Plate Number'
          : getFieldName(field);
      final error = scanResults.findErrorForSource(field);
      final value =
          field == RapidPassField.apor && aporCodes.containsKey(e.value)
              ? aporCodes[e.value] + ' (${e.value})'
              : e.value;

      return error == null
          ? PassResultsTableRow(label: label, value: value)
          : PassResultsTableRow(
              label: label, value: value, errorMessage: error.errorMessage);
    }).toList();

    if (scanResults.isValid()) {
      playNotificationApproved();
    } else {
      playNotificationRegected();
    }

    final card = scanResults.isValid()
        ? PassResultsCard(
            iconName: 'check-2x',
            headerText: scanResults.resultMessage.toUpperCase(),
            data: passResultsData,
            color: green300)
        : PassResultsCard(
            iconName: 'error',
            headerText: scanResults.resultMessage.toUpperCase(),
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
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
                      child: SizedBox(
                        height: 48,
                        width: 300.0,
                        child: RaisedButton(
                          shape: new RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24.0)),
                          onPressed: () => _scanAndNavigate(context),
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
                          vertical: 8.0, horizontal: 20.0),
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

  Future _scanAndNavigate(final BuildContext context) async {
    final scanResults = await MainMenu.scanAndValidate(context);
    Navigator.popAndPushNamed(context, '/scanResults', arguments: scanResults);
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
