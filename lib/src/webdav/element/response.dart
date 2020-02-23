import 'package:xml/xml.dart';
import '../../core/parser_factory.dart';
import '../webdav_element.dart';
import '../webdav_parser.dart';
import 'propstat.dart';

/// <response> element described in RFC 4918
class WebDavResponse extends WebDavElement {
  WebDavResponse() : super('response');

  /// The 'href' element contains an HTTP URL pointing to
  /// a WebDAV resource when used in the 'response' container.
  String href;

  String getHref() {
    return href;
  }

  List<WebDavPropStat> propStats;
}

class ResponseParser extends WebDavParser<WebDavResponse> {
  @override
  WebDavResponse getGenericInstance() => WebDavResponse();

  List<WebDavResponse> parse(XmlNode node) {
    return super.parse((node as XmlDocument).rootElement);
  }

  @override
  WebDavResponse parseSingle(XmlNode node) {
    var response = node as XmlElement;
    var responseObj = WebDavResponse();

    responseObj.href = ParserFactory.create()
        .getParser('href', webDavNamespace)
        .parse(response)
        .first;
    responseObj.propStats = PropStatParser().parse(response);
    return responseObj;
  }
}
