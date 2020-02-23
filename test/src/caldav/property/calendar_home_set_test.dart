import 'package:caldav/src/caldav/property/calendar_home_set.dart';
import 'package:test/test.dart';

import 'package:xml/xml.dart' as xml;

void main() {
  test('process XML node', () async {
    var processor = CalendarHomeSetParser();

    var node = xml.parse(
        '<data xmlns:x0="urn:ietf:params:xml:ns:caldav" xmlns:x1="DAV:"><x0:calendar-home-set><x1:href>test</x1:href></x0:calendar-home-set></data>');

    var result = processor.parse(node.firstChild);
    expect(result.length, 1);
    expect(result.first.url, 'test');
  });

  test('process empty XML node', () async {
    var processor = CalendarHomeSetParser();

    var node = xml.parse(
        '<data xmlns:x0="urn:ietf:params:xml:ns:caldav"><x0:calendar-home-set/></data>');

    var result = processor.parse(node.firstChild);
    expect(result.length, 1);
    expect(result.first.url, null);
  });
}
