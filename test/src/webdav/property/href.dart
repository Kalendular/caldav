import 'package:caldav/src/webdav/property/_properties.dart';
import 'package:test/test.dart';

import 'package:xml/xml.dart' as xml;

void main() {
  test('process href XML node', () async {
    var processor = HrefParser();

    var node =
        xml.parse('<data xmlns:x0="DAV:"><x0:href>test</x0:href></data>');

    var result = processor.parse(node.firstChild);
    expect(result.length, 1);
    expect(result.first, 'test');
  });

  test('process empty href XML node', () async {
    var processor = HrefParser();

    var node = xml.parse('<data xmlns:x0="DAV:"><x0:href/></data>');

    var result = processor.parse(node.firstChild);
    expect(result.length, 1);
    expect(result.first, null);
  });
}
