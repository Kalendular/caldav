import 'package:xml/xml.dart';
import '../webdav_element.dart';
import '../webdav_parser.dart';

class WebDavCurrentUserPrincipal extends WebDavElement {
  WebDavCurrentUserPrincipal() : super('current-user-principal');

  String url;
}

class CurrentUserPrincipalParser
    extends WebDavParser<WebDavCurrentUserPrincipal> {
  @override
  WebDavCurrentUserPrincipal getGenericInstance() =>
      WebDavCurrentUserPrincipal();

  @override
  WebDavCurrentUserPrincipal parseSingle(XmlNode node) {
    var returnValue = WebDavCurrentUserPrincipal();
    returnValue.url = parseChildren(node.children);
    return returnValue;
  }
}
