import 'package:flutter/material.dart';
import 'package:rapidpass_checkpoint/models/faq_model.dart';

class Faqs extends StatefulWidget {
  @override
  _FaqsState createState() => _FaqsState();
}

class _FaqsState extends State<Faqs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FAQs'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          Faq _faqItem = Faq.listOfFaqs[index];

          return _faqItem.efaq == eFAQ.HEADING
              ? Padding(
                  padding: EdgeInsets.fromLTRB(16, 20, 16, 10),
                  child: Text(
                    '${Faq.listOfFaqs[index].headerValue}',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                )
              : ExpansionTile(
                  title: Text(_faqItem.headerValue),                  
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(16, 10, 16, 16),
                      child: _faqItem.expandedValue,
                    ),
                  ],
                );
        },
        itemCount: Faq.listOfFaqs.length,
      ),
    );
  }
}
