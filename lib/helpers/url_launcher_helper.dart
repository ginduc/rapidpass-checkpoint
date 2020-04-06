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
}
