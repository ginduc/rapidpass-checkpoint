import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rapidpass_checkpoint/components/flavor_banner.dart';
import 'package:rapidpass_checkpoint/helpers/dialog_helper.dart';
import 'package:rapidpass_checkpoint/models/check_plate_or_control_args.dart';
import 'package:rapidpass_checkpoint/models/control_code.dart';
import 'package:rapidpass_checkpoint/models/scan_results.dart';
import 'package:rapidpass_checkpoint/services/pass_validation_service.dart';
import 'package:rapidpass_checkpoint/services/usage_log_service.dart';
import 'package:rapidpass_checkpoint/themes/default.dart';

class CheckPlateOrControlScreen extends StatefulWidget {
  final CheckPlateOrControlScreenModeType screenModeType;

  const CheckPlateOrControlScreen(this.screenModeType);

  @override
  State<CheckPlateOrControlScreen> createState() {
    return _CheckPlateOrControlScreenState();
  }
}

class _CheckPlateOrControlScreenState extends State<CheckPlateOrControlScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _formFieldTextEditingController;

  CheckPlateOrControlScreenModeType get _screenModeType =>
      widget.screenModeType;

  bool _formHasErrors = false;

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

  @override
  void deactivate() {
    super.deactivate();
    _formFieldTextEditingController.clear();
  }

  @override
  void didChangeDependencies() {
    _formFieldTextEditingController.clear();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
    _formFieldTextEditingController.dispose();
  }

  String _getAppBarText() {
    if (_screenModeType == CheckPlateOrControlScreenModeType.plate) {
      return "Check Plate Number";
    } else {
      return "Check Control Number";
    }
  }

  String _getHelpText() {
    if (_screenModeType == CheckPlateOrControlScreenModeType.plate) {
      return "Type the vehicle's plate number or conduction sticker below:";
    } else {
      return "Type the person's control number receive via SMS below:";
    }
  }

  String _getFormFieldLabel() {
    if (_screenModeType == CheckPlateOrControlScreenModeType.plate) {
      return "Plate Number / Conduction Sticker";
    } else {
      return "Control Number";
    }
  }

  String _getSubmitCtaText() {
    if (_screenModeType == CheckPlateOrControlScreenModeType.plate) {
      return "Check Plate Number";
    } else {
      return "Check Control Number";
    }
  }

  @override
  Widget build(BuildContext context) {
    return FlavorBanner(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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
                            maxLength: _screenModeType ==
                                    CheckPlateOrControlScreenModeType.plate
                                ? 11
                                : 10,
                            maxLengthEnforced: true,
                            inputFormatters: [
                              WhitelistingTextInputFormatter(
                                  RegExp("[a-zA-Z0-9]"))
                            ],
                            autofocus: true,
                            onChanged: (String value) => setState(() {}),
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
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(26.0),
                  child: FlatButton(
                    child: Text(
                      _getSubmitCtaText(),
                      style: TextStyle(fontSize: 16),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                    color: green300,
                    disabledColor: Colors.grey[300],
                    textColor: Colors.white,
                    padding: EdgeInsets.all(16.0),
                    onPressed: _formFieldTextEditingController.text.isEmpty
                        ? null
                        : () {
                            _formKey.currentState.validate();

                            if (!_formHasErrors) {
                              _validate(context);
                            }
                          },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _validate(BuildContext context) async {
    final PassValidationService passValidationService =
        Provider.of<PassValidationService>(context, listen: false);
    ScanResults scanResults;
    CheckPlateOrControlScreenResults checkResults;

    if (_screenModeType == CheckPlateOrControlScreenModeType.plate) {
      scanResults = await passValidationService
          .checkPlateNumber(_formFieldTextEditingController.text);

      await UsageLogService.insertUsageLog(context, scanResults);

      if (scanResults.allRed) {
        DialogHelper.showAlertDialog(
          context,
          title: 'Plate Number Unregistered',
          message:
              'The Vehicle\'s Plate Number is not yet registered to the app.',
        );
        return;
      }
    } else if (_screenModeType == CheckPlateOrControlScreenModeType.control) {
      final String normalizedControlCode =
          _formFieldTextEditingController.text.toUpperCase();
      if (!ControlCode.isValid(normalizedControlCode)) {
        DialogHelper.showAlertDialog(
          context,
          title: 'Control Number Invalid',
          message:
              'You\'ve entered an invalid Control Number. Kindly type again your number.',
        );
        return;
      }
      scanResults =
          await passValidationService.checkControlCode(normalizedControlCode);

      await UsageLogService.insertUsageLog(context, scanResults);
    }

    checkResults =
        CheckPlateOrControlScreenResults(_screenModeType, scanResults);
    Navigator.pushNamed(
      context,
      '/checkPlateOrCodeResults',
      arguments: checkResults,
    );
  }
}
