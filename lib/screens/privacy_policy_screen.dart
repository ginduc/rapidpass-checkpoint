import 'package:flutter/material.dart';

class PrivacyPolicy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy Policy'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.fromLTRB(20, 25, 20, 25),
        children: <Widget>[
          Text(
            'We, at DevCon, respect your right to privacy and want you to understand how we collect, use, and share information ' +
                'about you. This Privacy Policy covers our data processing practices and describes your data privacy rights under ' +
                'the Philippine Data Privacy Act of 2012. ',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 16),
          Text(
            'This Privacy Policy applies when you visit or use the RapidPass.ph application, or related services (the “Services”) of ' +
                'the platform. By using the Services, you agree to the terms of this Privacy Policy. ',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 16),
          Text(
            'What data we collect from you',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'We collect certain data from you directly, like information you enter yourself and data from third-party platforms you ' +
                'connect with in and through DevCon.',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 16),
          Text(
            'Data you provide to us',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            'We may collect your personal information depending on how you use the Services. When you use the Services, including through ' +
                'a third-party platform, we collect any information you directly provide including the following:',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 16),
          Text(
            '1. Account data:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            'In order to use certain features of the Services, you need to provide your personal information. When you create or update' +
                ' your account, we collect and store the data you provide such as your name, email address, and mobile number.',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 16),
          Text(
            '2. Profile data:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            'You may choose to provide your profile information which may be viewable by others.',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 16),
          Text(
            '3. Data about your accounts on other services:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            'We may obtain certain information through your social media or other online accounts if they are connected to your use of ' +
                'our Services. The information we receive depends on what information you decide to give us via your privacy settings or the ' +
                'platform or service. If you access or use our Services through a third-party platform or service, or click on any third-party ' +
                'links, the collection, use, and sharing of your data will also be subject to the privacy policies and other agreements of ' +
                'that third party.',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 16),
          Text(
            '4. Transaction data:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            'We collect and use certain information, including your frequency of subscriptions, business industry information - including, ' +
                'but not limited to your plug-ins and applications you have downloaded or are subscribed to. For your security, DevCon does ' +
                'not collect or store sensitive bank account information. However, BUX will need to access DevCon users’ information for ' +
                'generating the checkout of transactions.',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 16),
          Text(
            'How we get data about you',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            'Registration shall be done via the RapidPass.ph app. During application for the Service, you must provide the necessary ' +
                'information needed such as, but not limited to, your complete name, email address, mobile number, company or business name, ' +
                'company or business position, company or business industry, vehicle type, etc.',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 16),
          Text(
            'Analytics',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            'We use Google Analytics. This tool will help us analyze your use of the Services, including information like, how often ' +
                'you visit, events within the Services, and usage and performance data. We use this data to improve the Services, better ' +
                'understand how the Services perform on different devices, and provide information that may be of interest to you.',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 16),
          Text(
            'What we use your data for',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            'We use your data to do things such as provide our Services, communicate with you, secure against fraud and abuse, improve ' +
                'and update our Services, and as required by law or necessary, for safety and integrity.',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 16),
          Text(
            'Who we share your data with',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            'We share certain data about you with our third-party service providers. We may also share data in other ways if it is ' +
                'aggregated or de-identified, or if we get your consent.',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 16),
          Text(
            'Data security',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            'We use appropriate security based on the type and sensitivity of data being stored. As with any internet- enabled system, ' +
                'there is always a risk of unauthorized access, so it’s important to protect your device or account and to contact us if ' +
                'you suspect any unauthorized access to your device or account. DevCon takes appropriate security measures to protect ' +
                'against unauthorized access, alteration, disclosure, or destruction of your personal data that we collect and store. ' +
                'These measures vary based on the type and sensitivity of the data. Unfortunately; however, no system can be 100% secured, ' +
                'so we cannot guarantee that communications between you and DevCon, the Services, or any information provided to us (in ' +
                'connection with the data we collect through the Services) will be free from unauthorized access by third parties. ' +
                'Your password is an important part of our security system, and it is your responsibility to protect it. You should not ' +
                'share your password with any third party, and if you believe your password or account has been compromised, you should ' +
                'change it immediately and contact us with any concerns.',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 16),
          Text(
            'Your data privacy rights',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            'You have certain rights around the use of your data, including the ability to opt out of promotional emails, and collection ' +
                'of your data by certain analytics providers. You can update or terminate your account from within our Services, and can ' +
                'also contact us for individual rights requests about your personal data.',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 16),
          Text(
            'Contact us',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            'If you have any questions, concerns, or disputes regarding our Privacy Policy, please feel free to contact ',
            style: TextStyle(fontSize: 16),
          ),
          Text(
            'RapidPass-dctx@devcon.ph',
            style: TextStyle(
              fontSize: 16,
              decoration: TextDecoration.underline,
              color: Colors.blueAccent,  
            ),
            
          ),
        ],
      ),
    );
  }
}
