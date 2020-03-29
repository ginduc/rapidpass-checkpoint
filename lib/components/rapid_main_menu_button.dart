import 'package:flutter/material.dart';
import 'package:rapidpass_checkpoint/themes/default.dart';

class RapidMainMenuButton extends StatefulWidget {
  final String title;
  final String iconPath;
  final VoidCallback onPressed;

  RapidMainMenuButton({
    @required this.title,
    @required this.iconPath,
    @required this.onPressed,
  });

  @override
  _RapidMainMenuButtonState createState() => _RapidMainMenuButtonState();
}

class _RapidMainMenuButtonState extends State<RapidMainMenuButton> {
  Color _textColor = Colors.deepPurple, _backgroundColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 90,
        width: 300,
        child: RaisedButton(
          color: _backgroundColor,
          onHighlightChanged: (value) {
            setState(() {
              if (value) {
                _textColor = Colors.white;
                _backgroundColor = deepPurple600;
              } else {
                _textColor = Colors.deepPurple;
                _backgroundColor = Colors.white;
              }
            });
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide(
              width: 2.0,
              color: deepPurple600,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image(
                  width: 40.0,
                  image: AssetImage(widget.iconPath),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(widget.title,
                      style: Theme.of(context).textTheme.title.copyWith(
                          fontSize: 22,
                          color: _textColor,
                          fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          onPressed: widget.onPressed,
        ),
      ),
    );
  }
}
