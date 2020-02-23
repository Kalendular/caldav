import 'package:xml/xml.dart';
import '../webdav_element.dart';
import '../webdav_parser.dart';

class WebDavDisplayName extends WebDavElement {
  WebDavDisplayName() : super('displayname');

  String displayName;
}

class DisplayNameParser extends WebDavParser<WebDavDisplayName> {
  @override
  WebDavDisplayName getGenericInstance() => WebDavDisplayName();

  @override
  WebDavDisplayName parseSingle(XmlNode node) {
    var returnValue = WebDavDisplayName();
    returnValue.displayName = parseChildren(node.children);
    return returnValue;
  }
}
