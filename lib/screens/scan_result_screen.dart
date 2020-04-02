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
class ScanResultScreen extends StatefulWidget {
  final ScanResults scanResults;

  const ScanResultScreen(this.scanResults);

  @override
  _ScanResultScreenState createState() => _ScanResultScreenState();
}

class _ScanResultScreenState extends State<ScanResultScreen> {
  @override
  void initState() {
    super.initState();

    if (widget.scanResults.isValid()) {
      _playNotificationApproved();
    } else {
      _playNotificationRejected();
    }
  }

  @override
  Widget build(BuildContext context) {
    final qrData = widget.scanResults.qrData;
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
      final error = widget.scanResults.findErrorForSource(field);
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

    final card = widget.scanResults.isValid()
        ? PassResultsCard(
            iconName: 'check-2x',
            headerText: widget.scanResults.resultMessage,
            data: passResultsData,
            color: green300)
        : PassResultsCard(
            iconName: 'error',
            headerText: widget.scanResults.resultMessage,
            subHeaderText: widget.scanResults.resultSubMessage,
            data: passResultsData,
            color: Colors.red,
            allRed: widget.scanResults.allRed,
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
                    const Padding(padding: EdgeInsets.only(top: 10.0)),
                    Container(
                      padding: EdgeInsets.only(
                        top: 8.0,
                        right: 0.5,
                        bottom: 20,
                        left: 1,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          if (widget.scanResults.isValid() == true)
                            OutlineButton(
                              highlightedBorderColor: green300,
                              splashColor: green300.withOpacity(0.6),
                              borderSide: BorderSide(color: green300),
                              focusColor: green300,
                              child: Text(
                                'View More Information',
                                style: TextStyle(fontSize: 16),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              color: green300,
                              textColor: green300,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 17.0),
                              onPressed: () =>
                                  Navigator.pushNamed(context, '/viewMoreInfo'),
                            ),
                          if (widget.scanResults.isValid() == true)
                            Padding(padding: EdgeInsets.only(top: 16.0)),
                          FlatButton(
                            splashColor: green300.withOpacity(0.2),
                            child: Text('Scan another QR',
                                style: TextStyle(fontSize: 16)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            color: green300,
                            textColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 34.0),
                            onPressed: () => _scanAndNavigate(context),
                          ),
                          Padding(padding: EdgeInsets.only(top: 16.0)),
                          OutlineButton(
                            highlightedBorderColor: green300,
                            splashColor: green300.withOpacity(0.6),
                            borderSide: BorderSide(color: green300),
                            focusColor: green300,
                            child: Text(
                              'Return to checker page',
                              style: TextStyle(fontSize: 16),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            color: green300,
                            textColor: green300,
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 17.0),
                            onPressed: () => Navigator.popUntil(
                                context, ModalRoute.withName('/menu')),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ))),
    );
  }

  Future _scanAndNavigate(final BuildContext context) async {
    final scanResults = await MainMenu.scanAndValidate(context);
    if (scanResults is ScanResults) {
      Navigator.popAndPushNamed(context, '/scanResults',
          arguments: scanResults);
    }
  }

  Future<AudioPlayer> _playNotificationApproved() async {
    AudioCache cache = new AudioCache();
    return await cache.play("notification_approved.mp3");
  }

  Future<AudioPlayer> _playNotificationRejected() async {
    AudioCache cache = new AudioCache();
    return await cache.play("notification_denied.mp3");
  }
}
