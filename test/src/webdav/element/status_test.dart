import 'package:caldav/src/webdav/element/_elements.dart';
import 'package:test/test.dart';
import 'package:xml/xml.dart' as xml;
import '../../../_fixtures/caldav_data.dart' as data;

void main() {
  test('parse status element', () async {
    var parser = StatusParser();
    var node = xml.parse(data.nextCloudCurrentUser);
    var result = parser.parse(node);

    // has 1 status field each
    expect(result.length, 3);
    expect(result.elementAt(0).httpStatus, 'HTTP/1.1 200 OK');
    expect(result.elementAt(1).httpStatus, 'HTTP/1.1 200 OK');
    expect(result.elementAt(2).httpStatus, 'HTTP/1.1 200 OK');
  });
}
