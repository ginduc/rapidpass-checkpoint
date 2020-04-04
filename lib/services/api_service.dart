import 'package:csv/csv.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

abstract class IApiService {
  Future<void> authenticateDevice(int timestamp, int pageSize, int pageNum);
  Future<void> registerDevice();
  Future<void> getRegisteredDeviceDetails(String deviceId);
  Future<void> getBatchPasses();
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
  }) : this.httpClientAdapter = httpClientAdapter != null ? httpClientAdapter : DefaultHttpClientAdapter();

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
  Future<void> getBatchPasses() async {
    final Dio client = Dio(BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: 5000,
        receiveTimeout: 60000,
        contentType: Headers.jsonContentType));
    client.httpClientAdapter = httpClientAdapter;
    final Response response = await client.get(getBatchPassesPath,
        queryParameters: {'lastSyncOn': 0, 'pageNumber': 0, 'pageSize': 10});
    print(response.data['meta']);
    final csv = response.data['csv'];
    final list = CsvToListConverter(eol: '\n').convert(csv);
    print(list[0]);
    print(list.length);
    return null;
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
