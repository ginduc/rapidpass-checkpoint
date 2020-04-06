import 'package:url_launcher/url_launcher.dart';

class URLLauncherHelper {
  static launchMail(String emailAddress) async {
    final url = 'mailto:$emailAddress?subject=Questions/Concerns';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  static launchFacebook(String fbID, String fbName) async {
    final String fbProtocolUrl = 'fb://page/$fbID';
    final String fallbackUrl = 'https://www.facebook.com/$fbName';
    try {
      bool launched = await launch(fbProtocolUrl,
          forceSafariVC: false, forceWebView: false);

      if (!launched) {
        await launch(fallbackUrl, forceSafariVC: false, forceWebView: false);
      }
    } catch (e) {
      await launch(fallbackUrl, forceSafariVC: false, forceWebView: false);
    }
  }

  static launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
