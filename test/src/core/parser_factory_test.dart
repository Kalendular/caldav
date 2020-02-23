import 'package:caldav/src/core/parser.dart';
import 'package:caldav/src/core/parser_factory.dart';
import 'package:test/test.dart';
import 'package:xml/xml.dart' as xml;

class TestParser extends Parser<String> {
  @override
  String getGenericInstance() => '';

  @override
  String get nodeName => 'multistatus';

  @override
  String get nodeNamespace => 'DAV:';

  @override
  String parseSingle(xml.XmlNode node) => '';
}

void main() {
  test('get parser instance', () {
    var parserFactory = ParserFactory.getMock([TestParser()]);
    var parser = parserFactory.getParser('multistatus', 'DAV:');

    expect(parser is TestParser, true);
    expect(parser.nodeName, 'multistatus');
    expect(parser.nodeNamespace, 'DAV:');
  });
}
