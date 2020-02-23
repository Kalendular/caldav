import 'package:caldav/src/webdav/property/current_user_principal.dart';
import 'package:test/test.dart';

import 'package:xml/xml.dart' as xml;

void main() {
  test('process XML node', () async {
    var processor = CurrentUserPrincipalParser();

    var node = xml.parse(
        '<data xmlns:x0="DAV:"><x0:current-user-principal><x0:href>test</x0:href></x0:current-user-principal></data>');

    var result = processor.parse(node.firstChild);
    expect(result.length, 1);
    expect(result.first.url, 'test');
  });

  test('process empty XML node', () async {
    var processor = CurrentUserPrincipalParser();

    var node =
        xml.parse('<data xmlns:x0="DAV:"><x0:current-user-principal/></data>');

    var result = processor.parse(node.firstChild);
    expect(result.length, 1);
    expect(result.first.url, null);
  });
}
