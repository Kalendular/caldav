import 'package:xml/xml.dart';
import '../webdav_element.dart';
import '../webdav_parser.dart';

/// <status> element described in RFC 4918
class WebDavStatus extends WebDavElement {
  WebDavStatus(this.httpStatus) : super('status');

  String httpStatus;

  /// Holds a single HTTP status-line.
  String getStatus() {
    return httpStatus;
  }

  @override
  String toString() {
    return httpStatus;
  }
}

class StatusParser extends WebDavParser<WebDavStatus> {
  @override
  WebDavStatus getGenericInstance() => WebDavStatus(null);

  @override
  WebDavStatus parseSingle(XmlNode node) {
    return WebDavStatus(node.text);
  }
}
