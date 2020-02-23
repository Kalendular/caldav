import 'package:xml/xml.dart';
import '../../core/xmlelement.dart' as core;
import '../webdav_element.dart';
import '../webdav_parser.dart';

/// <prop> element described in RFC 4918
class WebDavProp extends WebDavElement {
  /// Constructor
  WebDavProp() : super('prop');

  /// This element MUST NOT contain text or mixed content."
  List<core.XmlElement> content;
}

/// Parses <prop> XML nodes into [WebDavProp] object
class PropParser extends WebDavParser<WebDavProp> {
  /// Creates a new PropParser. Unparsable children will be ignored.
  PropParser() : super(skipUnparsableChildren: true);

  @override
  WebDavProp getGenericInstance() => WebDavProp();

  @override
  WebDavProp parseSingle(XmlNode node) {
    var element = node as XmlElement;
    var propObj = WebDavProp();
    propObj.content = parseChildren(element.children);
    return propObj;
  }
}
