import 'package:flutter/material.dart';
import 'package:rapidpass_checkpoint/themes/default.dart';

class MainMenuButton extends StatelessWidget {
  final String text;
  final String iconName;
  final VoidCallback onPressed;

  MainMenuButton(this.text, this.iconName, this.onPressed);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 300.0,
        child: OutlineButton(
          borderSide: BorderSide(width: 2.0, color: deepPurple900),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: Row(
            children: <Widget>[
              Image(
                width: 80.0,
                image: AssetImage('assets/' + this.iconName),
              ),
              Text(this.text),
            ],
          ),
          onPressed: this.onPressed,
        ),
      ),
    );
  }
}
