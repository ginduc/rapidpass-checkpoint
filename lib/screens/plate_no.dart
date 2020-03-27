import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'main_menu.dart';


class PlateNoScreen extends StatefulWidget {
  PlateNoScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _PlateNoScreenState createState() => _PlateNoScreenState();
}

class _PlateNoScreenState extends State<PlateNoScreen> {


  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
       
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              onPressed: () {
                Navigator.of(context).push(
                  CupertinoPageRoute(
                  builder: (context) => MainMenuScreen(checkPointName: 'Camp Aguinaldo 2', openScan: true) //MainMenuScreen('Camp Aguinaldo', false),

                ));

              },
              child: const Text(
                'Enabled Button',
                style: TextStyle(fontSize: 20)
              ),
            ),
          ],
        ),
      ),
     
    );
  }
}
