import 'package:xml/xml.dart';
import '../webdav_element.dart';
import '../webdav_parser.dart';

class HrefParser extends WebDavParser<String> {
  @override
  String getGenericInstance() => '';

  @override
  String get nodeName => 'href';

  @override
  String get nodeNamespace => webDavNamespace;

  @override
  String parseSingle(XmlNode node) {
    return node.text;
  }
}
