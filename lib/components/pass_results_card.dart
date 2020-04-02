import 'package:flutter/material.dart';
import 'package:rapidpass_checkpoint/helpers/dialog_helper.dart';

const borderRadius = 12.0;

class PassResultsTableRow {
  final String label;
  final String value;
  final String errorMessage;

  PassResultsTableRow({this.label, this.value, String errorMessage})
      : this.errorMessage = errorMessage;
}

/// This is used to display the "pass" or "fail" card
class PassResultsCard extends StatelessWidget {
  final String iconName;
  final String headerText;
  final String subHeaderText;
  final List<PassResultsTableRow> data;
  final Color color;
  final bool allRed;
  const PassResultsCard(
      {this.iconName,
      this.headerText,
      this.subHeaderText,
      this.data,
      this.color,
      this.allRed = false});

  @override
  Widget build(BuildContext context) {
    final tableTextStyle = TextStyle(fontSize: 16.0);
    final tableChildren = this.data.map((row) {
      if (this.allRed || row.errorMessage != null) {
        return TableRow(children: [
          GestureDetector(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Text(
                  row.label,
                  style: tableTextStyle.copyWith(color: Colors.red),
                ),
              ),
              onTap: () => DialogHelper.showAlertDialog(context,
                  title: this.headerText,
                  message: row.errorMessage ?? this.headerText)),
          GestureDetector(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Text(
                  row.value,
                  textAlign: TextAlign.right,
                  style: tableTextStyle.copyWith(
                      color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ),
              onTap: () => DialogHelper.showAlertDialog(context,
                  title: this.headerText,
                  message: row.errorMessage ?? this.headerText))
        ]);
      } else {
        return TableRow(children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0),
            child: Text(
              row.label,
              style: tableTextStyle,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0),
            child: Text(
              row.value,
              textAlign: TextAlign.right,
              style: tableTextStyle.copyWith(fontWeight: FontWeight.bold),
            ),
          )
        ]);
      }
    }).toList();
    return Container(
        decoration: BoxDecoration(
            border: Border.all(color: this.color, width: 1.0),
            borderRadius: BorderRadius.circular(borderRadius)),
        child: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(borderRadius),
                      topRight: Radius.circular(borderRadius)),
                  color: this.color,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image(
                          width: 80.0,
                          image: AssetImage('assets/${this.iconName}.png'),
                        ),
                      ),
                      if (this.headerText != null)
                        Text(
                          this.headerText.toUpperCase(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold),
                        ),
                      SizedBox(
                        height: 10,
                      ),
                      if (this.subHeaderText != null) ...[
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          this.subHeaderText.toUpperCase(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold),
                        )
                      ]
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Table(children: tableChildren)),
              )
            ])));
  }

}
