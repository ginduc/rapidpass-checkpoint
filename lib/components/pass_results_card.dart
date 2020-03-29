import 'package:flutter/material.dart';

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
  final List<PassResultsTableRow> data;
  final Color color;
  final bool allRed;
  PassResultsCard(
      {this.iconName,
      this.headerText,
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
            onTap: () => _showDialog(context,
                title: this.headerText, body: row.errorMessage),
          ),
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
            onTap: () => _showDialog(context,
                title: this.headerText, body: row.errorMessage),
          )
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
                      Text(
                        this.headerText,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold),
                      )
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

  void _showDialog(BuildContext context, {String title, String body}) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(title),
          content: new Text(body),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
