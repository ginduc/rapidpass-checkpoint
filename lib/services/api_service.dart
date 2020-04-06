import 'dart:developer';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:rapidpass_checkpoint/data/app_database.dart';
import 'package:rapidpass_checkpoint/data/pass_csv_to_json_converter.dart';
import 'package:rapidpass_checkpoint/models/control_code.dart';
import 'package:rapidpass_checkpoint/models/database_sync_state.dart';

abstract class IApiService {
  Future<void> authenticateDevice({String imei, String masterKey});
  Future<DatabaseSyncState> getBatchPasses(DatabaseSyncState state);
  Future<void> verifyPlateNumber(String plateNumber);
  Future<void> verifyControlNumber(String controlNumber);
}

class ApiService extends IApiService {
  final HttpClientAdapter httpClientAdapter;
  final String baseUrl;

  static const authenticateDevicePath = '/checkpoint/auth';
  static const getBatchPassesPath = '/batch/access-passes';

  ApiService({
    @required this.baseUrl,
    HttpClientAdapter httpClientAdapter,
  }) : this.httpClientAdapter = httpClientAdapter != null
            ? httpClientAdapter
            : DefaultHttpClientAdapter();

  @override
  Future authenticateDevice({final String imei, final String masterKey}) async {
    final Dio client = Dio(BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: 30000,
        receiveTimeout: 60000,
        contentType: Headers.jsonContentType));
    client.httpClientAdapter = httpClientAdapter;
    final Response response = await client.post(authenticateDevicePath,
        data: {'imei': imei, 'masterKey': masterKey});
    final data = response.data;
    debugPrint('${inspect(data)}');
    return data;
  }

  @override
  Future<DatabaseSyncState> getBatchPasses(
      final DatabaseSyncState state) async {
    debugPrint('getBatchPasses.state: $state');
    if (state.totalPages > 0 && state.pageNumber > state.totalPages) {
      state.passesForInsert = List();
      return state;
    }
    final Dio client = Dio(BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: 30000,
        receiveTimeout: 60000,
        contentType: Headers.jsonContentType));
    client.httpClientAdapter = httpClientAdapter;
    final Response response =
        await client.get(getBatchPassesPath, queryParameters: {
      'lastSyncOn': state.lastSyncOn,
      'pageNumber': state.pageNumber,
      'pageSize': state.pageSize
    });
    final data = response.data;
    debugPrint('${inspect(data)}');
    if (state.totalPages == 0) {
      state.totalPages = data['totalPages'];
      state.totalRows = data['totalRows'];
    }
    final list = response.data['data'];
    final listLength = list.length;
    if (list.length < 2) {
      return state;
    }
    debugPrint('Got ${listLength - 1} rows...');
    final List<String> headers = list[0].cast<String>().toList();
    debugPrint('headers => $headers');
    final passCsvToJsonConverter = PassCsvToJsonConverter(headers: headers);
    final List<ValidPassesCompanion> receivedPasses = List();

    for (final row in list.sublist(1, listLength)) {
      try {
        final json = passCsvToJsonConverter.convert(row);
        debugPrint('Got pass ${ControlCode.encode(json['controlCode'])}');
        final validPass = ValidPass.fromJson(json);
        final companion = validPass.createCompanion(true);
        receivedPasses.add(companion);
      } on FormatException catch (e) {
        debugPrint(e.toString());
      }
    }
    state.passesForInsert = receivedPasses;
    state.pageNumber = state.pageNumber + 1;
    return state;
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
