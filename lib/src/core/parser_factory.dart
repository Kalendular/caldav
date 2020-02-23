import '../caldav/property/calendar_home_set.dart';
import '../webdav/element/_elements.dart';
import '../webdav/property/_properties.dart';
import 'parser.dart';

/// Used for finding the parser for a XMl element
class ParserFactory {
  static final ParserFactory _instance = ParserFactory._internal();

  /// Creates a singleton [ParserFactory] instance
  factory ParserFactory.create() => _instance;

  /// Used to get a non-Singleton ParserFactory with a custom list
  factory ParserFactory.getMock(List<Parser> parser) =>
      ParserFactory._withList(parser);

  static List<Parser> parsers;

  ParserFactory._internal() {
    parsers = [
      // WebDav Elements
      PropParser(),
      PropStatParser(),
      ResponseParser(),
      StatusParser(),

      // WebDav Properties
      HrefParser(),
      CurrentUserPrincipalParser(),
      DisplayNameParser(),

      // CalDav Properties
      CalendarHomeSetParser(),
    ];
  }

  ParserFactory._withList(List<Parser> parserList) {
    parsers = parserList;
  }

  /// Returns a [Parser] for the XML object identified by [name] and [namespace]
  Parser getParser(String name, String namespace) {
    return parsers.firstWhere((parser) =>
        parser.nodeName == name && parser.nodeNamespace == namespace);
  }
}
