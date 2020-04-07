import 'package:flutter/material.dart';

final EdgeInsets padding =
    EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0);

//TODO: Add real information to View More Information Page
class ViewMoreInfoScreen extends StatelessWidget {
  const ViewMoreInfoScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('View More Information')),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 30.0),
          child: Column(children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SectionHeading('RapidPass Information'),
                InfoDetails(
                  subtitle: 'Control Number',
                  title: 'OAH981JK',
                ),
                InfoDetails(
                  subtitle: 'Plate Number',
                  title: 'AOZ 1531',
                ),
                InfoDetails(
                  subtitle: 'Access Type',
                  title: 'Medical Services',
                ),
                InfoDetails(
                  subtitle: 'Approved By',
                  title: 'DOH',
                ),
                InfoDetails(
                  subtitle: 'Valid Until',
                  title: '9:00 PM; Apr. 12, 2020',
                ),
                InfoDetails(
                  subtitle: 'Last Used',
                  title: 'April 1, 2020',
                ),
                InfoDetails(
                  subtitle: 'Reason',
                  title: 'Frontliner',
                ),
                SectionDivider(),
                SectionHeading('Personal Information'),
                InfoDetails(
                  subtitle: 'Full Name',
                  title: 'Dela Cruz Jr., Juancho',
                ),
                InfoDetails(
                  subtitle: 'Email',
                  title: 'jdcjr@mmc.com',
                ),
                InfoDetails(
                  subtitle: 'Mobile Number',
                  title: '09186999999',
                ),
                SectionDivider(),
                SectionHeading('Company Information'),
                InfoDetails(
                  subtitle: 'Company/Institution Name',
                  title: 'Makati Medical Centre',
                ),
                InfoDetails(
                  subtitle: 'ID Type',
                  title: 'PRC ID',
                ),
                InfoDetails(
                  subtitle: 'ID Number',
                  title: '08091657',
                ),
                SectionDivider(),
                SectionHeading('Origin'),
                InfoDetails(
                  subtitle: 'Street',
                  title: 'St. Jude Street',
                ),
                InfoDetails(
                  subtitle: 'City',
                  title: 'Quezon City',
                ),
                InfoDetails(
                  subtitle: 'Province',
                  title: 'Metro Manila',
                ),
                SectionDivider(),
                SectionHeading('Destination'),
                InfoDetails(
                  subtitle: 'Street',
                  title: '2 Amorsolo Street',
                ),
                InfoDetails(
                  subtitle: 'City',
                  title: 'Makati City',
                ),
                InfoDetails(
                  subtitle: 'Province',
                  title: 'Metro Manila',
                )
              ],
            )
          ]),
        ));
  }
}

class InfoDetails extends StatelessWidget {
  InfoDetails({Key key, this.title, this.subtitle, this.onTap});

  final String title;
  final String subtitle;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap == null ? () {} : onTap,
      child: Container(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(subtitle,
                style: TextStyle(fontSize: 17.0, color: Colors.grey[600])),
            const Padding(padding: EdgeInsets.only(bottom: 10.0)),
            Text(title,
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold))
          ],
        ),
      ),
    );
  }
}

class SectionDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding.left, vertical: 8.0),
      child: const Divider(thickness: 2.0),
    );
  }
}

class SectionHeading extends StatelessWidget {
  SectionHeading(this.text, {Key key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: padding,
        child: Text(text,
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 17.0,
                fontWeight: FontWeight.bold)));
  }
}
