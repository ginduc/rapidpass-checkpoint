import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ViewMoreInfoScreen extends StatelessWidget {
  const ViewMoreInfoScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('More Details')),
      body: Center(
        child: Padding(
          padding: EdgeInsets.only(top: 24.0),
          child: Text("Control Number"),
        ),
      ),
    );
  }
}
