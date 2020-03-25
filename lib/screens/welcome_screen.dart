import 'dart:async';

import 'package:device_id/device_id.dart';
import 'package:flutter/material.dart';
import 'package:rapidpass_checkpoint/themes/default.dart';

class WelcomeScreenState extends State<WelcomeScreen> {
  Future<String> imeiFuture = getImei();

  /// Since ImeiPlugin works asynchronously, we need this to be async
  static Future<String> getImei() async {
    var imei = await DeviceId.getIMEI;
    var uuid = await DeviceId.getID;
    debugPrint('imei => $imei');
    debugPrint('uuid => $uuid');
    return imei;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: this.imeiFuture,
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          String imei = snapshot.hasData
              ? 'IMEI: ${snapshot.data}'
              : 'Retreiving IMEI...';
          final themeData = Theme.of(context);
          final colorScheme = themeData.colorScheme.copyWith(
              surface: deepPurple900,
              background: deepPurple900,
              primary: deepPurple900,
              primaryVariant: green300,
              onPrimary: Colors.white,
              onSurface: Colors.white,
              onBackground: Colors.white,
              onError: Colors.white,
              onSecondary: Colors.white);
          final textTheme = themeData.textTheme.apply(bodyColor: Colors.white);
          final primaryTextTheme =
              themeData.primaryTextTheme.apply(bodyColor: Colors.white);
          return Theme(
            data: themeData.copyWith(
                buttonTheme: themeData.buttonTheme.copyWith(
                    buttonColor: green300,
                    colorScheme: colorScheme,
                    textTheme: ButtonTextTheme.accent),
                textTheme: textTheme,
                primaryTextTheme: primaryTextTheme),
            child: Scaffold(
              backgroundColor: deepPurple600,
              body: Container(
                margin: const EdgeInsets.symmetric(vertical: 48.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 32.0),
                        child: Image(
                          image: AssetImage("assets/rapidpass_logo.png"),
                        ),
                      ),
                      Text('Welcome to',
                          style: TextStyle(fontSize: 27.0),
                          textAlign: TextAlign.center),
                      Text('RapidPass.ph\nCheckpoint',
                          softWrap: true,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 32.0),
                          textAlign: TextAlign.center),
                      Spacer(),
                      Text(imei),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: SizedBox(
                          height: 48,
                          width: 300.0,
                          child: RaisedButton(
                            shape: new RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24.0)),
                            onPressed: () {
                              Navigator.pushNamed(context, "/menu");
                            },
                            child: Text("Start",
                                style: TextStyle(
                                    // Not sure how to get rid of color: Colors.white here
                                    color: Colors.white,
                                    fontSize: 18.0)),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}

class WelcomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return WelcomeScreenState();
  }
}
