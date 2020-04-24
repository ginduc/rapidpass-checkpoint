import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:rapidpass_checkpoint/components/flavor_banner.dart';
import 'package:rapidpass_checkpoint/data/app_database.dart';
import 'package:rapidpass_checkpoint/models/apor.dart';
import 'package:rapidpass_checkpoint/models/qr_data.dart';
import 'package:rapidpass_checkpoint/models/scan_results.dart';
import 'package:rapidpass_checkpoint/services/usage_log_service.dart';
import 'package:rapidpass_checkpoint/themes/default.dart';

class UsageLogDetailArgs {
  final int timestamp;
  UsageLogDetailArgs(this.timestamp);
}

class UsageLogDetailScreen extends StatefulWidget {
  final UsageLogDetailArgs args;
  const UsageLogDetailScreen(this.args);

  @override
  State<StatefulWidget> createState() {
    return UsageLogDetailScreenState();
  }
}

class UsageLogDetailScreenState extends State<UsageLogDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return FlavorBanner(
      child: Scaffold(
          appBar: AppBar(title: Text('Usage Log Details')),
          body: Padding(
              padding: EdgeInsets.all(8.0),
              child: FutureBuilder(
                  future: UsageLogService.getUsageLogs(context, widget.args.timestamp),
                  builder: (bContext, bSnapshot) {
                    if (bSnapshot.connectionState == ConnectionState.done) {
                      final List<UsageLogInfo> logs = bSnapshot.data;
                      return ListView.separated(
                        itemCount: logs.length,
                        separatorBuilder: (context, count) {
                          return const SizedBox(height: 10);
                        },
                        itemBuilder: (bContext, index) =>
                            _buildLogCard(logs[logs.length - index - 1]),
                      );
                    } else {
                      return CircularProgressIndicator();
                    }
                  }))),
    );
  }

  var _headerOnly = [
    ScanResultStatus.INVALID_RAPIDPASS_SIGNATURE,
    ScanResultStatus.INVALID_RAPIDPASS_QRDATA,
    ScanResultStatus.INVALID_QRCODE,
    ScanResultStatus.PLATE_NUMBER_NOT_FOUND,
    ScanResultStatus.CONTROL_CODE_NOT_FOUND,
    ScanResultStatus.CONTROL_NUMBER_NOT_FOUND,
    ScanResultStatus.UNKNOWN_STATUS,
  ];

  bool _isHeaderOnly(ScanResultStatus status) {
    for (ScanResultStatus s in _headerOnly) {
      if (s == status) return true;
    }
    return false;
  }

  _buildLogCard(UsageLogInfo log) {
    Color color = log.usageLog.status == 0 ? green300 : Colors.red;
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: color, width: 1.0),
          borderRadius: BorderRadius.circular(12.0)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildHeader(
              ScanResultStatus.getStatusFromValue(log.usageLog.status)),
          _buildBody(log),
        ],
      ),
    );
  }

  _buildHeader(ScanResultStatus status) {
    double height;
    Color color;
    String icon;

    if (status == ScanResultStatus.ENTRY_APPROVED) {
      height = 50.0;
      color = green300;
      icon = 'check';
    } else {
      height = 60.0;
      color = Colors.red;
      icon = 'error';
    }

    return Row(
      children: <Widget>[
        Expanded(
            flex: 6,
            child: Container(
                height: height,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(11.0),
                      bottomLeft: Radius.circular(11.0)),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(status.mainMessage,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold)),
                      status != ScanResultStatus.ENTRY_APPROVED
                          ? Text(status.subMessage,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w500))
                          : SizedBox.shrink(),
                    ],
                  ),
                ))),
        Expanded(
          flex: 1,
          child: Container(
            height: height,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(11.0),
                  bottomRight: Radius.circular(11.0)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SvgPicture.asset(
                'assets/$icon.svg',
                color: Colors.white,
                width: 65.0,
              ),
            ),
          ),
        )
      ],
    );
  }

  _buildBody(UsageLogInfo log) {
    UsageLog usageLog = log.usageLog;
    ScanResults scanResults = log.scanResult;
    ScanResultStatus status =
        ScanResultStatus.getStatusFromValue(log.usageLog.status);

    return Container(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            !_isHeaderOnly(status)
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _buildFieldRow(
                        'Pass Type',
                        scanResults.qrData.passType == PassType.Individual
                            ? 'I - INDIVIDUAL'
                            : 'V - VEHICHLE',
                        _isErrorField(
                            log.scanResult.errors, RapidPassField.passType),
                      ),
                      _buildFieldRow(
                        'Control Code',
                        scanResults.qrData.controlCodeAsString(),
                        _isErrorField(
                            log.scanResult.errors, RapidPassField.controlCode),
                      ),
                      _buildFieldRow(
                        'ID Number',
                        scanResults.qrData.idOrPlate,
                        _isErrorField(
                            log.scanResult.errors, RapidPassField.idOrPlate),
                      ),
                      _buildFieldRow(
                        'APOR',
                        '${scanResults.qrData.apor} - ${aporCodes[scanResults.qrData.apor]}',
                        _isErrorField(
                            log.scanResult.errors, RapidPassField.apor),
                      ),
                      _buildFieldRow(
                        'Valid From',
                        '${DateFormat('MMM dd, yyyy hh:mm aaa').format(new DateTime.fromMillisecondsSinceEpoch(scanResults.qrData.validFrom * 1000))}',
                        _isErrorField(
                            log.scanResult.errors, RapidPassField.validFrom),
                      ),
                      _buildFieldRow(
                        'Valid Until',
                        '${DateFormat('MMM dd, yyyy hh:mm aaa').format(new DateTime.fromMillisecondsSinceEpoch(scanResults.qrData.validUntil * 1000))}',
                        _isErrorField(
                            log.scanResult.errors, RapidPassField.validUntil),
                      )
                    ],
                  )
                : Column(
                    children: <Widget>[
                      _buildFieldRow(
                          _getInputType(status), usageLog.inputData, true)
                    ],
                  ),
            _buildFooter(log),
          ],
        ),
      ),
    );
  }

  _buildFieldRow(name, value, isError) {
    Color color = isError ? Colors.red : Colors.black;
    return Row(
      children: <Widget>[
        Expanded(
          flex: 2,
          child: Text(name,
              style: TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w500, color: color)),
        ),
        Expanded(
            flex: 5,
            child: Text(value,
                textAlign: TextAlign.right,
                style: TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w500, color: color)))
      ],
    );
  }

  _buildFooter(UsageLogInfo log) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 10.0,
        ),
        Text(
          '${DateFormat('MMM dd, yyyy hh:mm aaa').format(new DateTime.fromMillisecondsSinceEpoch(log.usageLog.timestamp))}'
          ' via ${_getModeName(log.usageLog.mode)}',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  _getModeName(int mode) {
    String name = '';
    switch (mode) {
      case 0:
        name = 'QR Code';
        break;
      case 1:
        name = 'Control Number';
        break;
      case 2:
        name = 'Control Code';
        break;
      case 3:
        name = 'Plate Number';
        break;
    }
    return name;
  }

  _getInputType(ScanResultStatus status) {
    String inputType = "Input Data";
    switch (status) {
      case ScanResultStatus.CONTROL_NUMBER_NOT_FOUND:
        inputType = 'Control Number';
        break;
      case ScanResultStatus.PLATE_NUMBER_NOT_FOUND:
        inputType = 'Plate Number';
        break;
      case ScanResultStatus.CONTROL_CODE_NOT_FOUND:
        inputType = 'Control Code';
        break;
    }
    return inputType;
  }

  _isErrorField(List<ValidationError> errors, field) {
    for (final error in errors) {
      if (error.source == field) {
        return true;
      }
    }
    return false;
  }
}