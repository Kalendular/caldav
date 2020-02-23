import '../webdav/webdav_element.dart';

/// Namespace of CalDAV elements
const calDavNamespace = 'urn:ietf:params:xml:ns:caldav';

/// Base class for CalDAV elements
class CalDavElement extends WebDavElement {
  /// Constructor for CalDAV elements
  CalDavElement(name) : super(name) {
    namespace = calDavNamespace;
  }
}
