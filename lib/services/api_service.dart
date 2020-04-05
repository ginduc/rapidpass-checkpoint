import 'dart:developer';

import 'package:csv/csv.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:rapidpass_checkpoint/data/app_database.dart';
import 'package:rapidpass_checkpoint/data/pass_csv_to_json_converter.dart';
import 'package:rapidpass_checkpoint/models/control_code.dart';

class DatabaseSyncState {
  final int lastSyncOn;
  final int pageSize;
  int totalPages = 0;
  int totalRows = 0;
  int pageNumber = 0;
  int insertedRowsCount = 0;
  String statusMessage;
  Exception exception;
  List<ValidPassesCompanion> passesForInsert = List();
  DatabaseSyncState({@required this.lastSyncOn, this.pageSize = 100});

  @override
  String toString() {
    return 'DatabaseSyncState(lastSyncOn: $lastSyncOn, pageSize: $pageSize, totalPages: $totalPages, totalRows: $totalRows, pageNumber: $pageNumber, insertedRowsCount: $insertedRowsCount)';
  }
}

abstract class IApiService {
  Future<void> authenticateDevice(int timestamp, int pageSize, int pageNum);
  Future<void> registerDevice();
  Future<void> getRegisteredDeviceDetails(String deviceId);
  Future<DatabaseSyncState> getBatchPasses(DatabaseSyncState state);
  Future<void> getBatchPass(String refId);
  Future<void> getQrCode(String refId);
  Future<void> verifyPlateNumber(String plateNumber);
  Future<void> verifyControlNumber(String controlNumber);
}

class ApiService extends IApiService {
  final HttpClientAdapter httpClientAdapter;
  final String baseUrl;

  ApiService({
    @required this.baseUrl,
    HttpClientAdapter httpClientAdapter,
  }) : this.httpClientAdapter = httpClientAdapter != null
            ? httpClientAdapter
            : DefaultHttpClientAdapter();

  @override
  Future<void> authenticateDevice(int timestamp, int pageSize, int pageNum) {
    // TODO: implement authenticateDevice
    return null;
  }

  @override
  Future<void> getBatchPass(String refId) {
    // TODO: implement getBatchPass
    return null;
  }

  static const getBatchPassesPath = '/batch/access-passes';

  @override
  Future<DatabaseSyncState> getBatchPasses(
      final DatabaseSyncState state) async {
    if (state.totalPages > 0 && state.pageNumber > state.totalPages) {
      state.passesForInsert = List();
      return state;
    }
    final Dio client = Dio(BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: 5000,
        receiveTimeout: 60000,
        contentType: Headers.jsonContentType));
    client.httpClientAdapter = httpClientAdapter;
    final Response response =
        await client.get(getBatchPassesPath, queryParameters: {
      'lastSyncOn': state.lastSyncOn,
      'pageNumber': state.pageNumber,
      'pageSize': state.pageSize
    });
    final metadata = response.data['meta'];
    debugPrint('${inspect(metadata)}');
    if (state.totalPages == 0) {
      state.totalPages = metadata['totalPages'];
      state.totalRows = metadata['totalRows'];
    }
    final csv = response.data['csv'];
    final list = CsvToListConverter(eol: '\n').convert(csv);
    final listLength = list.length;
    debugPrint('Got ${listLength - 1} rows...');
    final List<String> headers = list[0].cast<String>().toList();
    debugPrint('headers => $headers');
    final passCsvToJsonConverter = PassCsvToJsonConverter(headers: headers);
    final List<ValidPassesCompanion> validPasses =
        list.sublist(1, listLength).map((row) {
      try {
        final json = passCsvToJsonConverter.convert(row);
        debugPrint('Got pass ${ControlCode.encode(json['controlCode'])}');
        final validPass = ValidPass.fromJson(json);
        return validPass.createCompanion(true);
      } on FormatException catch (e) {
        debugPrint(e.toString());
        return null;
      }
    }).toList()
          ..removeWhere((e) => e == null);
    state.passesForInsert = validPasses;
    state.pageNumber = state.pageNumber + 1;
    return state;
  }

  @override
  Future<void> getQrCode(String refId) {
    // TODO: implement getQrCode
    return null;
  }

  @override
  Future<void> getRegisteredDeviceDetails(String deviceId) {
    // TODO: implement getRegisteredDeviceDetails
    return null;
  }

  @override
  Future<void> registerDevice() {
    // TODO: implement registerDevice
    return null;
  }

  @override
  Future<void> verifyControlNumber(String controlNumber) {
    // TODO: implement verifyControlNumber
    return null;
  }

  @override
  Future<void> verifyPlateNumber(String plateNumber) {
    // TODO: implement verifyPlateNumber
    return null;
  }
}
