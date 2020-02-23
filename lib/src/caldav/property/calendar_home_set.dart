import 'package:xml/xml.dart';
import '../caldav_element.dart';
import '../caldav_parser.dart';

/// CalDAV property "calendar-home-set"
class CalDavCalendarHomeSet extends CalDavElement {
  /// Constructor
  CalDavCalendarHomeSet() : super('calendar-home-set');

  /// Calendar home URL
  String url;
}

/// Creates [CalDavCalendarHomeSet] objects from a XmlNode
class CalendarHomeSetParser extends CalDavParser<CalDavCalendarHomeSet> {
  @override
  CalDavCalendarHomeSet getGenericInstance() => CalDavCalendarHomeSet();

  @override
  CalDavCalendarHomeSet parseSingle(XmlNode node) {
    var returnValue = CalDavCalendarHomeSet();
    returnValue.url = parseChildren(node.children);
    return returnValue;
  }
}
