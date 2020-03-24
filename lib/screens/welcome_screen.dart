import 'package:flutter/material.dart';
import 'package:rapidpass_checkpoint/themes/default.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  style: TextStyle(color: Colors.white, fontSize: 27.0),
                  textAlign: TextAlign.center),
              Text('RapidPass.ph\nCheckpoint',
                  softWrap: true,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 32.0),
                  textAlign: TextAlign.center),
              Spacer(),
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
                    color: rapidPassColorScheme.secondary,
                    textColor: Colors.white,
                    child: Text("Start", style: TextStyle(fontSize: 18.0)),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
