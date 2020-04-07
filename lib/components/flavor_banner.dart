import 'package:flutter/material.dart';
import 'package:rapidpass_checkpoint/flavor.dart';

class FlavorBanner extends StatelessWidget {
  final Widget child;
  FlavorBanner({@required this.child});

  @override
  Widget build(BuildContext context) {
    if (Flavor.isProduction) return child;
    return Stack(
      children: <Widget>[child, buildBanner(context)],
    );
  }

  static Widget buildBanner(final BuildContext context,
      {final String text, final Color color}) {
    return Container(
      width: 50,
      height: 50,
      child: CustomPaint(
        painter: BannerPainter(
            message: 'dev',
            textDirection: Directionality.of(context),
            layoutDirection: Directionality.of(context),
            location: BannerLocation.topStart,
            color: Colors.blue),
      ),
    );
  }
}
