import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rapidpass_checkpoint/themes/default.dart';

class RoundedButton extends StatelessWidget {
  final double height;
  final double minWidth;
  final EdgeInsetsGeometry padding;
  final String text;
  final Function onPressed;

  RoundedButton(
      {this.text,
      this.height = 48.0,
      this.minWidth = 200.0,
      this.padding = const EdgeInsets.symmetric(vertical: 40.0),
      this.onPressed});

  @override
  Widget build(BuildContext context) {
    final contextTheme = Green.buildFor(context);
    return Padding(
      padding: this.padding,
      child: SizedBox(
        height: this.height,
        width: this.minWidth,
        child: ButtonTheme(
          height:
              this.height > 0 ? this.height : contextTheme.buttonTheme.height,
          minWidth: this.minWidth > 0
              ? this.minWidth
              : contextTheme.buttonTheme.minWidth,
          textTheme: ButtonTextTheme.accent,
          buttonColor: contextTheme.accentColor,
          highlightColor: contextTheme.highlightColor,
          colorScheme:
              contextTheme.colorScheme.copyWith(secondary: Colors.white),
          child: RaisedButton(
            child: Text(
              this.text,
              style: TextStyle(fontSize: 18.0),
            ),
            onPressed: this.onPressed,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0)),
          ),
        ),
      ),
    );
  }
}
