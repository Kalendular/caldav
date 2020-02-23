import 'package:http/http.dart';

import '../caldav.dart';

class EventRepository {
  /// Path to calendar
  String _calendarPath;

  /// CalDav Client instance to be used
  final CalDavClient _client;

  /// Creates a new instance from a calendar path
  EventRepository(this._calendarPath, this._client);

  /// Path to calendar
  String get calendarPath => _calendarPath;

  /// Create a new event in a calendar identified by [calendarPath]
  void createEvent() async {
    var eventFileName =
        'event-${DateTime.now().millisecondsSinceEpoch.toString()}';
    var calendarEntry = '''BEGIN:VCALENDAR
VERSION:2.0
PRODID:-//Example Corp.//CalDAV Client//EN
BEGIN:VEVENT
UID:20010712T182145Z-123401@example.com
DTSTAMP:20200212T182145Z
DTSTART:20200214T170000Z
DTEND:20200215T040000Z
SUMMARY:Test Event
END:VEVENT
END:VCALENDAR''';

    var response = await _client.put('$_calendarPath/$eventFileName.ics',
        body: calendarEntry);
    if (response.statusCode == 301) {
      _calendarPath = response.headers['location'];
      return createEvent();
    }

    // successful PUT request returns HTTP 201 CREATED
    if (response.statusCode != 201) {
      // ERROR OCCURRED
      // TODO: Parse error body.
      throw ClientException(response.body);
    }
  }
}
