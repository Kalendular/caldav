import 'package:caldav/src/webdav/property/_properties.dart';
import 'package:test/test.dart';

import 'package:xml/xml.dart' as xml;

void main() {
  test('process displayname XML node', () async {
    var processor = DisplayNameParser();

    var node = xml.parse(
        '<data xmlns:x0="DAV:"><x0:displayname>test</x0:displayname></data>');

    var result = processor.parse(node.firstChild);
    expect(result.length, 1);
    expect(result.first.displayName, 'test');
  });

  test('process empty displayname XML node', () async {
    var processor = DisplayNameParser();

    var node = xml.parse('<data xmlns:x0="DAV:"><x0:displayname/></data>');

    var result = processor.parse(node.firstChild);
    expect(result.length, 1);
    expect(result.first.displayName, null);
  });
}
