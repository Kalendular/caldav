import 'dart:convert';
import 'package:test/test.dart';
import 'package:caldav/src/caldav/client.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import '../../_fixtures/caldav_data.dart' as data;

class MockClient extends Mock implements http.BaseClient {}

void main() {
  test('test regularbase url construction', () async {
    var httpMock = MockClient();
    when(httpMock.send(any)).thenAnswer(
        (_) async => http.StreamedResponse(http.ByteStream.fromBytes([]), 200));
    var client =
        CalDavClient('host', 'user', 'password', 'path', httpClient: httpMock);
    expect(client.baseUrl, 'http://host/path');
  });

  test('test HTTPS base url construction', () async {
    var httpMock = MockClient();
    when(httpMock.send(any)).thenAnswer(
        (_) async => http.StreamedResponse(http.ByteStream.fromBytes([]), 200));
    var client = CalDavClient('host', 'user', 'password', 'path',
        protocol: 'https', httpClient: httpMock);
    expect(client.baseUrl, 'https://host/path');
  });

  test('test different port base url construction', () async {
    var httpMock = MockClient();
    when(httpMock.send(any)).thenAnswer(
        (_) async => http.StreamedResponse(http.ByteStream.fromBytes([]), 200));
    var client = CalDavClient('host', 'user', 'password', 'path',
        port: 123, httpClient: httpMock);
    expect(client.baseUrl, 'http://host:123/path');
  });

  test('test getting current user principal', () async {
    var httpMock = MockClient();

    var responses = [data.nextCloudCurrentUser];
    when(httpMock.send(any)).thenAnswer((_) async => http.StreamedResponse(
        http.ByteStream.fromBytes(utf8.encode(responses.removeAt(0))), 200));

    var client = CalDavClient('host', 'user', 'password', 'remote.php/caldav',
        port: 123, httpClient: httpMock);
    var response = await client.getCurrentUserPrincipal();
    expect(response, '/remote.php/caldav/principals/saitho/');
  });

  test('test getting user home calendar', () async {
    var httpMock = MockClient();

    var responses = [data.nextCloudCurrentUser, data.nextCloudUserHomeCalendar];
    when(httpMock.send(any)).thenAnswer((_) async => http.StreamedResponse(
        http.ByteStream.fromBytes(utf8.encode(responses.removeAt(0))), 200));

    var client = CalDavClient('host', 'user', 'password', 'remote.php/caldav',
        port: 123, httpClient: httpMock);
    var response = await client.getUserHomeCalendar();
    expect(response, '/remote.php/caldav/calendars/saitho/');
  });

  test('test getting calendars', () async {
    var httpMock = MockClient();

    when(httpMock.send(any)).thenAnswer((_) async => http.StreamedResponse(
        http.ByteStream.fromBytes(utf8.encode(data.nextCloudUserCalendars)),
        200));

    var client = CalDavClient('host', 'user', 'password', 'remote.php/caldav',
        port: 123, httpClient: httpMock);
    var response =
        await client.getCalendars('/remote.php/caldav/calendars/saitho/');
    expect(response.length, 4);
    expect(response.elementAt(0).displayName, 'Personal');
    expect(response.elementAt(0).path,
        '/remote.php/caldav/calendars/saitho/personal-1/');
    expect(response.elementAt(1).displayName, 'Geburtstage von Kontakten');
    expect(response.elementAt(1).path,
        '/remote.php/caldav/calendars/saitho/contact_birthdays/');
    expect(response.elementAt(2).displayName, null);
    expect(response.elementAt(2).path,
        '/remote.php/caldav/calendars/saitho/inbox/');
    expect(response.elementAt(3).displayName, null);
    expect(response.elementAt(3).path,
        '/remote.php/caldav/calendars/saitho/outbox/');
  });
}
