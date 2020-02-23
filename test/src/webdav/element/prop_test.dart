import 'package:caldav/src/webdav/element/_elements.dart';
import 'package:test/test.dart';
import 'package:xml/xml.dart' as xml;
import '../../../_fixtures/caldav_data.dart' as data;

void main() {
  test('parse prop element', () async {
    var parser = PropParser();
    var node = xml.parse(data.nextCloudCurrentUser);
    var result = parser.parse(node);

    // has three results with 1 property each
    expect(result.length, 3);
    expect(result.elementAt(0).content.length, 1);
    expect(result.elementAt(1).content.length, 1);
    expect(result.elementAt(2).content.length, 1);
  });
}
