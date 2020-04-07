import 'package:flutter/material.dart';
import 'package:rapidpass_checkpoint/components/rounded_button.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SettingsScreenState();
  }
}

class SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Settings')),
        body: Center(
            child: SingleChildScrollView(
                child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            InkWell(
              child: RoundedButton(
                minWidth: 300.0,
                text: 'Rescan Master QR Code',
                onPressed: () => debugPrint('Pressed'),
              ),
            )
          ],
        ))));
  }
}
