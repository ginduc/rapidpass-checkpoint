import 'package:dio/dio.dart';
import 'package:test/test.dart';
import 'package:vcr/vcr.dart';

void main() {
  setUp(() {
    // noop
  });
  tearDown(() async {
    // noop
  });

  group('ApiService test group', () {
    test('http.get', () async {
      try {
        VcrAdapter adapter = VcrAdapter();
        Dio client = Dio();
        client.httpClientAdapter = adapter;
        adapter.useCassette('batch/access-passes');
        Response response = await client.get(
            'https://rapidpass-api.azurewebsites.net/api/v1/batch/access-passes?lastSyncOn=0&pageNumber=0&pageSize=10');
        print(response);
      } catch (e) {
        print(e);
      }
    });
  });
}
