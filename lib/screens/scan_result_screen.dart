import 'package:flutter/material.dart';
import 'package:rapidpass_checkpoint/components/pass_results_card.dart';
import 'package:rapidpass_checkpoint/models/scan_results.dart';
import 'package:rapidpass_checkpoint/screens/main_menu.dart';
import 'package:rapidpass_checkpoint/services/pass_validation_service.dart';
import 'package:rapidpass_checkpoint/themes/default.dart';

const borderRadius = 12.0;

/// Pass or Fail screen
class ScanResultScreen extends StatelessWidget {
  ScanResults scanResults;

  ScanResultScreen(this.scanResults);

  @override
  Widget build(BuildContext context) {
    final qrData = scanResults.qrData;
    // TODO ValidatorService
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
      return error == null
          ? PassResultsTableRow(label: label, value: e.value)
          : PassResultsTableRow(
              label: label, value: e.value, errorMessage: error.errorMessage);
    }).toList();
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
            color: Colors.red);
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
                    card,
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

  Future _scanAndNavigate(final BuildContext context) async {
    final qrData = await MainMenu.scan(context);
    final ScanResults scanResults = PassValidationService.validate(qrData);
    Navigator.popAndPushNamed(context, '/scanResults', arguments: scanResults);
  }
}
