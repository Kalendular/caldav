import 'dart:convert';

import 'package:caldav/src/event_repository.dart';
import 'package:test/test.dart';
import 'package:caldav/src/caldav/client.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import '../_fixtures/caldav_data.dart' as data;

class MockClient extends Mock implements http.BaseClient {}

void main() {
  test('create a new event', () async {
    var httpMock = MockClient();

    when(httpMock.send(any)).thenAnswer(
        (_) async => http.StreamedResponse(http.ByteStream.fromBytes([]), 201));

    var client = CalDavClient('host', 'user', 'password', 'remote.php/caldav',
        port: 123, httpClient: httpMock);
    var repo =
        EventRepository('/remote.php/caldav/calendars/saitho/personal', client);
    await repo.createEvent();
  });

  test('create a new event fails', () async {
    var httpMock = MockClient();

    when(httpMock.send(any)).thenAnswer((_) async => http.StreamedResponse(
        http.ByteStream.fromBytes(utf8.encode(data.nextCloudEventCreateError)),
        400));

    var client = CalDavClient('host', 'user', 'password', 'remote.php/caldav',
        port: 123, httpClient: httpMock);
    var repo =
        EventRepository('/remote.php/caldav/calendars/saitho/personal', client);

    try {
      await repo.createEvent();
      throw Exception("Expected http.ClientException");
    } on http.ClientException catch (_) {
      return;
    }
  });
}
