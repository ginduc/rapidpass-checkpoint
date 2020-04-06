import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

class Faq {
  Faq({
    @required this.headerValue,
    this.expandedValue,
    this.isExpanded = false,
    this.efaq = eFAQ.CONTENT,
  });

  Widget expandedValue;
  String headerValue;
  bool isExpanded;
  eFAQ efaq;

  static List<Faq> listOfFaqs = [
    Faq(
      headerValue: 'General',
      efaq: eFAQ.HEADING,
    ),
    Faq(
      headerValue: 'What is RapidPass.ph?',
      expandedValue: Text(
          'RapidPass.ph is a free website that helps in faster movement and access for front-liners and priority vehicles, ensuring the success of our country’s Enhanced Community Quarantine (ECQ).' +
              '\n\nUsers can register online, and apply for their digital pass, which will have the QR code that checkpoint personnel will scan for easier identification.'),
    ),
    Faq(
      headerValue: 'Who should use RapidPass.ph?',
      expandedValue: Text(
          'RapidPass.ph is for individuals, companies and vehicles needed for essential activities (e.g. first responders, front-liners, food suppliers, and assigned skeletal workforce in companies).' +
              '\n\nEventually, RapidPass.ph may be used by participating local governments in issuing digital quarantine passes and other authorized passes, if needed.'),
    ),
    Faq(
      headerValue: 'How do I register and get my digital pass?',
      expandedValue: Linkify(
        text: 'With a few easy steps, frontliners and personnel for priority vehicles can register and apply for digital approval in RapidPass.ph.' +
            '\n\nHow it works:' +
            '\n\n1. Register at http://www.rapidpass.ph' +
            '\n2. Follow the steps to apply for a digital pass' +
            '\n3. Once approved, the unique QR code with be sent through email and SMS' +
            '\n4. Print the code or save as a digital photo' +
            '\n5. For vehicles, we recommend printing the QR code and stick it on the windshield for visibility.' +
            '\n6. Present the code to enforcers who will scan it at designated checkpoints. Prepare your valid ID for inspection.' +
            '\n\n*For vehicles: apply for a separate pass for both the vehicles and the driver and passengers',
        onOpen: (link) async {
          if (await canLaunch(link.url)) {
            await launch(link.url);
          } else {
            throw 'Could not launch $link';
          }
        },
        linkStyle: TextStyle(color: Colors.blueAccent),
      ),
    ),
    Faq(
      headerValue: 'What if I don’t have a smart phone?',
      expandedValue: Text(
          'No problem! You can print the digital pass with the QR code on paper to show the checkpoint personnel, aside from saving the unique QR code on your mobile device. Remember to bring your valid ID at all times when travelling.'),
    ),
    Faq(
      headerValue: 'Registration',
      efaq: eFAQ.HEADING,
    ),
    Faq(
      headerValue:
          'I\'m having trouble registering an account. What should I do?',
      expandedValue: Text(
          'Please make sure that you provide a valid email address and mobile number for verification purposes.' +
              '\n\nIf you are registering your vehicle for a Vehicle pass, ensure that the vehicle information is accurate or is not yet registered in the RapidPass.ph system.'),
    ),
    Faq(
      headerValue: 'Who can register for an account?',
      expandedValue: Text(
          'Any individual or company/organization considered as essential, or needed for essential movement according to the guidelines of the Enhanced Community Quarantine (e.g. frontliners, medical workers, basic services, logistics, police, BPO workers, etc.)'),
    ),
    Faq(
      headerValue: 'Can I register multiple times?',
      expandedValue: Text(
          'You may only register once. One unique QR code is for one RapidPass.ph user. You will also need to apply for a QR code for each vehicle.'),
    ),
    Faq(
      headerValue: 'Can I use the RapidPass.ph immediately after registration?',
      expandedValue: Text(
          'Not yet. You have to wait for the unique QR code and approval code sent to your email address and SMS.'),
    ),
    Faq(
      headerValue: 'How long does it take to get an approval?',
      expandedValue: Text(
          'Approvals are usually released within 24 hours. While we are aware of the need to get the approvals as quickly as possible, we need to make sure that approvals are given to the right people and authorized vehicles.'),
    ),
    Faq(
      headerValue:
          'Can I still pass through checkpoints without the RapidPass.ph?',
      expandedValue: Text(
          'Yes, you may still go through checkpoints without a digital pass. The aim of RapidPass.ph is to make the checkpoint process easier for both front-liners and the checkpoint personnel.'),
    ),
    Faq(
      headerValue: 'How do I know that my registration is approved?',
      expandedValue: Text(
          'You will receive an email and/or SMS with your unique QR and Approval Code.'),
    ),
    Faq(
      headerValue: 'Do I just print the QR code and present this?',
      expandedValue: Text(
          'You can either present the printed QR Code or the Code on your mobile app.'),
    ),
    Faq(
      headerValue: 'Scanning',
      efaq: eFAQ.HEADING,
    ),
    Faq(
      headerValue: 'What do I do when I reach the checkpoint?',
      expandedValue: Text(
          'Please make sure your digital pass with the QR code is ready to present to checkpoint personnel. They will scan your pass, and may ask for your valid ID.'),
    ),
    Faq(
      headerValue: 'My QR Code does not work. What should I do?',
      expandedValue: Text(
          'If your QR code is printed on paper, please make sure it is not creased or or crumpled, and there is no object blocking it. If you’re using a saved QR code in your mobile phone, make sure it is shown clearly, and your screen is bright. If the problem persists, you may still go through the checkpoint using your ID, and the regular checkpoint procedures.'),
    ),
    Faq(
      headerValue: 'How long is my QR code valid?',
      expandedValue: Text(
          'It depends on the approval issued to you. Please check your email for the validity of the QR pass.'),
    ),
    Faq(
      headerValue: 'Can other people use my digital pass with QR code?',
      expandedValue: Text(
          'No. Your unique QR code is tied to your user information, and valid ID. The QR code can only be used by the approved person or vehicle registered in the system.'),
    ),
    Faq(
      headerValue: 'Do I need another ID if I have a RapidPass.ph?',
      expandedValue: Text(
          'Yes, checkpoints may still ask for your valid ID along with your digital pass with QR code. We recommend having your valid ID with you while travelling.'),
    ),
    Faq(
      headerValue: 'Additional Pass',
      efaq: eFAQ.HEADING,
    ),
    Faq(
      headerValue: 'Can I request for additional pass for my companion?',
      expandedValue: Text(
          'Yes. Your companion needs to register to get his or her own RapidPass.ph unique QR code. This is also the same for additional vehicles.'),
    ),
    Faq(
      headerValue: 'I lost my QR code, can I request for a replacement?',
      expandedValue: Text(
          'Yes. You can request for another QR code by going to the RapidPass.ph website. Same approval policies will apply.'),
    ),
    Faq(
      headerValue: 'About RapidPass.ph',
      efaq: eFAQ.HEADING,
    ),
    Faq(
      headerValue: 'Who developed RapidPass.ph?',
      expandedValue: Text(
          'RapidPass.ph was developed by DCTx or DEVCON Community of Technology Experts, a volunteer-based worldwide community of experts from various fields working in partnership with the Philippine Department of Science and Technology (DOST) to develop digital platforms and solutions to help fight the COVID-19 pandemic.'),
    ),
    Faq(
      headerValue: 'I want to know more about RapidPass.ph',
      expandedValue: Container(
        padding: EdgeInsets.only(bottom: 50),
        alignment: Alignment.centerLeft,
        child: Linkify(
          onOpen: (link) async {
            if (await canLaunch(link.url)) {
              await launch(link.url);
            } else {
              throw 'Could not launch $link';
            }
          },
          text: 'Visit our website at http://www.rapidpass.ph',
          linkStyle: TextStyle(color: Colors.blueAccent),
        ),
      ),
    ),
  ];
}

enum eFAQ {
  HEADING,
  CONTENT,
}
