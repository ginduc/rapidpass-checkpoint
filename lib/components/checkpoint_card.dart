import 'package:flutter/material.dart';
import 'package:rapidpass_checkpoint/themes/default.dart';

class CheckPointCard extends StatelessWidget {
  final String checkPointName;

  CheckPointCard({this.checkPointName});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'RapidPass Checkpoint:',
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: deepPurple600),
            ),
          ),
          Container(
            width: 320.0,
            height: 50.0,
            decoration: BoxDecoration(color: deepPurple600),
            child: Center(
              child: Text(
                this.checkPointName,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
