import 'package:http/http.dart' as http;
import '../webdav/client.dart';
import '../webdav/property/_properties.dart';
import './calendar.dart';
import 'property/calendar_home_set.dart';

/// Provides CalDav specific functionality
class CalDavClient extends WebDavClient {
  /// Constructor for CalDav client
  CalDavClient(String host, String username, String password, String path,
      {String protocol = 'http', int port, http.BaseClient httpClient})
      : super(host, username, password, path,
            protocol: protocol, port: port, httpClient: httpClient);

  /// Returns URL of user's principal
  Future<String> getCurrentUserPrincipal() async {
    var requestResponse = await propfind('',
        body:
            '<x0:propfind xmlns:x0="DAV:"><x0:prop><x0:current-user-principal/></x0:prop></x0:propfind>');

    var prop = findProperty<WebDavCurrentUserPrincipal>(
        requestResponse.getByRequestPath(), WebDavCurrentUserPrincipal());
    return prop.url;
  }

  /// Returns path to user's home calendar
  Future<String> getUserHomeCalendar() async {
    var userPrincipal = await getCurrentUserPrincipal();
    var requestResponse = await propfind(userPrincipal,
        body:
            '<x0:propfind xmlns:x0="DAV:"><x0:prop><x1:calendar-home-set xmlns:x1="urn:ietf:params:xml:ns:caldav"/></x0:prop></x0:propfind>');
    var prop = findProperty<CalDavCalendarHomeSet>(
        requestResponse.getByRequestPath(), CalDavCalendarHomeSet());
    return prop.url;
  }

  /// Get a list of available calendars
  Future<List<CalDavCalendar>> getCalendars(String calendarPath) async {
    var body = '''<x0:propfind xmlns:x0="DAV:">
  <x0:prop>
    <x0:displayname/>
    <x0:principal-collection-set/>
  </x0:prop>
</x0:propfind>''';
    var responseObj = await propfind(calendarPath, body: body);
    // If response object for the request url does not have calendar
    // information -> remove it
    var responses = responseObj.getResponsesWithoutRequestHref();

    // ignore: prefer_collection_literals
    var list = List<CalDavCalendar>();
    for (var response in responses) {
      var displayName =
          findProperty<WebDavDisplayName>(response, WebDavDisplayName());
      list.add(
          CalDavCalendar(response.getHref(), displayName.displayName, this));
    }

    return list;
  }
}
