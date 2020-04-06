import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rapidpass_checkpoint/common/constants/rapid_asset_constants.dart';
import 'package:rapidpass_checkpoint/helpers/url_launcher_helper.dart';

class ContactUs extends StatelessWidget {
  static final String routeName = "/contact_us";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Us'),
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
            Text(
              'If you have any questions, remarks or suggestions, feel free to contact us ' +
                  'using the channels below. We will get back to you as soon as possible.',
            ),
            SizedBox(height: 25),
            InkWell(
              onTap: () => URLLauncherHelper.launchMail(
                'rapidpass-dctx@devcon.ph',
              ),
              child: _buildSocial(
                ctx: context,
                socialname: 'rapidpass-dctx@devcon.ph',
                socialIcon: FontAwesomeIcons.envelope,
              ),
            ),
            SizedBox(height: 15),
            InkWell(
              onTap: () => URLLauncherHelper.launchFacebook(
                  '114422283533958', 'rapidpassph'),
              child: _buildSocial(
                ctx: context,
                socialname: 'facebook.com/rapidpassph',
                socialIcon: FontAwesomeIcons.facebookF,
              ),
            ),
            SizedBox(height: 15),
            InkWell(
              onTap: () =>
                  URLLauncherHelper.launchUrl('https://twitter.com/rapidpassph'),
              child: _buildSocial(
                ctx: context,
                socialname: 'twitter.com/rapidpassph',
                socialIcon: FontAwesomeIcons.twitter,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocial(
      {String socialname, IconData socialIcon, BuildContext ctx}) {
    return Row(
      children: <Widget>[
        Icon(
          socialIcon,
          color: Theme.of(ctx).primaryColor,
          size: 20,
        ),
        SizedBox(width: 10),
        Text(
          socialname,
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
