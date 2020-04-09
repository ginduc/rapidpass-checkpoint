import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rapidpass_checkpoint/common/constants/rapid_asset_constants.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: SvgPicture.asset(
                      RapidAssetConstants.rapidPassLogoPurple,
                      width: MediaQuery.of(context).size.width * 0.2,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    'RapidPass.ph',
                    style: TextStyle(
                      fontSize: 22.5,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: <Widget>[
                  Text(
                    'RapidPass is powered by DCTx, a team of quarantined, yet passionate volunteers '
                    'who specialize in technology, under DevCon.ph COVID-19 Technology initiative.\n',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    'We exist to empathize, ideate, define, and design solutions to help solve ' +
                        'pressing COVID-19 pandemic problems.',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            Container(
              height: 80,
              child: Column(
                children: <Widget>[
                  Text(
                    'POWERED BY',
                    style: TextStyle(
                      fontSize: 10,
                      fontFamily: 'Work Sans',
                      letterSpacing: 2.5,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: SvgPicture.asset(
                          RapidAssetConstants.dctxLogo,
                          height: 23,
                        ),
                      ),
                      SizedBox(width: 40),
                      Container(
                        child: Image.asset(
                          RapidAssetConstants.devconLogo,
                          height: 20,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
