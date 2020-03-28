import 'package:flutter/material.dart';
import 'package:rapidpass_checkpoint/themes/default.dart';

class RapidMainMenuButton extends StatelessWidget {
  final String title;
  final String iconPath;
  final VoidCallback onPressed;

  RapidMainMenuButton({
    @required this.title,
    @required this.iconPath,
    @required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 90,
        width: 300,
        child: OutlineButton(
          borderSide: BorderSide(
            width: 2.0,
            color: deepPurple900,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image(
                  width: 40.0,
                  image: AssetImage(iconPath),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(this.title,
                      style: Theme.of(context).textTheme.title.copyWith(
                          fontSize: 22,
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          onPressed: this.onPressed,
        ),
      ),
    );
  }
}
