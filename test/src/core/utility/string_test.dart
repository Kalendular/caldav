import 'package:caldav/src/core/utility/string.dart';
import 'package:test/test.dart';

void main() {
  test('sanitize path', () {
    expect(StringUtility.sanitizePath('/test/', baseUrl: 'abc'),
        'test'); // remove first and last slash
    expect(StringUtility.sanitizePath('/test', baseUrl: 'abc'),
        'test'); // remove first slash
    expect(StringUtility.sanitizePath('test/', baseUrl: 'abc'),
        'test'); // remove last slash
    expect(StringUtility.sanitizePath('/abc/test/', baseUrl: 'abc'),
        'test'); // remove requestPath
    expect(StringUtility.sanitizePath('/abc/test', baseUrl: 'abc'),
        'test'); // remove requestPath
  });

  test('get full path', () {
    expect(StringUtility.getFullPath('abc', 'my-path'), '/abc/my-path/');
    expect(StringUtility.getFullPath('abc', '/my-path2/'), '/abc/my-path2/');
    expect(StringUtility.getFullPath('abc', ''), '/abc/');
  });
}
