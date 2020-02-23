import 'package:caldav/src/webdav/element/_elements.dart';
import 'package:test/test.dart';
import 'package:xml/xml.dart' as xml;
import '../../../_fixtures/caldav_data.dart' as data;

void main() {
  test('parse propstat element', () async {
    var parser = PropStatParser();
    var node = xml.parse(data.nextCloudCurrentUser);
    var result = parser.parse(node);

    // has 1 prop element and status each
    expect(result.length, 3);
    expect(result.elementAt(0).props.length, 1);
    expect(result.elementAt(0).status != null, true);
    expect(result.elementAt(1).props.length, 1);
    expect(result.elementAt(1).status != null, true);
    expect(result.elementAt(2).props.length, 1);
    expect(result.elementAt(2).status != null, true);
  });
}
