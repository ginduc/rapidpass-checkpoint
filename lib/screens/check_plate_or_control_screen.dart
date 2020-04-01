import 'package:flutter/material.dart';
import 'package:rapidpass_checkpoint/models/scan_results.dart';
import 'package:rapidpass_checkpoint/services/pass_validation_service.dart';
import 'package:rapidpass_checkpoint/themes/default.dart';

enum CheckPlateOrControlScreenModeType { plate, control }

class CheckPlateOrControlScreenArgs {
  final CheckPlateOrControlScreenModeType screenModeType;

  CheckPlateOrControlScreenArgs({@required this.screenModeType});
}

class CheckPlateOrControlScreen extends StatefulWidget {
  final CheckPlateOrControlScreenArgs args;

  const CheckPlateOrControlScreen({Key key, this.args}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CheckPlateOrControlScreenState();
  }
}

class _CheckPlateOrControlScreenState extends State<CheckPlateOrControlScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _formFieldTextEditingController;

  CheckPlateOrControlScreenArgs get _args => widget.args;

  bool _formHasErrors = false;

  // TODO: Remove this soon
  String _hardCodedValue = '123456';

  @override
  void initState() {
    super.initState();
    _formFieldTextEditingController = TextEditingController()
      ..addListener(() {
        if (_formHasErrors) {
          setState(() {
            _formHasErrors = false;
          });
        }
      });
  }

  String _getAppBarText() {
    if (_args.screenModeType == CheckPlateOrControlScreenModeType.plate) {
      return "Check Plate Number";
    } else {
      return "Check Control Number";
    }
  }

  String _getHelpText() {
    if (_args.screenModeType == CheckPlateOrControlScreenModeType.plate) {
      return "Type the vehicle's plate number or conduction sticker below:";
    } else {
      return "Type the person's control number receive via SMS below:";
    }
  }

  String _getFormFieldLabel() {
    if (_args.screenModeType == CheckPlateOrControlScreenModeType.plate) {
      return "Plate Number / Conduction Sticker";
    } else {
      return "Control Number";
    }
  }

  String _getSubmitCtaText() {
    if (_args.screenModeType == CheckPlateOrControlScreenModeType.plate) {
      return "Check Plate Number";
    } else {
      return "Check Control Number";
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final CheckPlateOrControlScreenArgs args =
        ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(_getAppBarText()),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 24.0),
                      child: Text(_getHelpText()),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 48.0),
                      child: Text(_getFormFieldLabel()),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 12.0),
                      child: SizedBox(
                        height: 80.0,
                        child: TextFormField(
                          controller: _formFieldTextEditingController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          autofocus: true,
                          validator: (String value) {
                            if (value.isEmpty) {
                              setState(() {
                                _formHasErrors = true;
                              });
                              return 'This field is required.';
                            } else if (value.isNotEmpty) {
                              setState(() {
                                _formHasErrors = false;
                              });
                              final ScanResults scanResults = (_args
                                          .screenModeType ==
                                      CheckPlateOrControlScreenModeType.plate)
                                  ? PassValidationService.checkPlateNumber(
                                      value)
                                  : PassValidationService.checkControlCode(
                                      value);
                              Navigator.pushNamed(
                                  context, '/checkPlateOrCodeResults',
                                  arguments: scanResults);
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: InkWell(
                  onTap: () {
                    _formKey.currentState.validate();

                    // TODO: Initial validation
                    if (_formFieldTextEditingController.text ==
                            _hardCodedValue &&
                        !_formHasErrors) {
                      // TODO: Add route to the success / invalid screen
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(16.0),
                          height: 48,
                          width: size.width * 0.80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24.0),
                            color: green300,
                          ),
                          child: Center(
                            child: Text(
                              _getSubmitCtaText(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
