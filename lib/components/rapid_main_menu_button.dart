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
    final size = MediaQuery.of(context).size;

    return InkWell(
      onTap: this.onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(8.0),
            margin: EdgeInsets.only(
              top: 16,
              bottom: 16,
            ),
            child: SizedBox(
              height: 90,
              width: size.width * 0.80,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2.0,
                    color: deepPurple900,
                  ),
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
                        padding: const EdgeInsets.only(left: 4.0),
                        child: Text(
                          this.title,
                          style: Theme.of(context).textTheme.title.copyWith(
                                fontSize: 22,
                                color: Colors.deepPurple,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
