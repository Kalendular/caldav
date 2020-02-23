import 'package:xml/xml.dart';
// ignore: implementation_imports
import 'package:xml/src/xml/utils/node_list.dart';
import '../core/parser.dart';
import '../core/parser_factory.dart';
import '../core/xmlelement.dart' as core;

/// Base class for WebDav parsers
abstract class WebDavParser<T> extends Parser<T> {
  /// if set to true children without parser definition will be skipped
  bool skipUnparsableChildren = false;

  /// Constructor for a WebDavParser.
  /// if skipUnparsableChildren is true,
  /// no exception is thrown when a child element has no parser
  WebDavParser({this.skipUnparsableChildren}) : super();

  /// parses child nodes by calling the respective parsers
  dynamic parseChildren(XmlNodeList<XmlNode> children) {
    if (children.isEmpty) {
      return null;
    }
    String stringReturnValue;
    // ignore: prefer_collection_literals
    var propList = List<core.XmlElement>();
    for (var child in children) {
      if (child is XmlText) {
        stringReturnValue = child.toString();

        // for some reason during unit test it had 3 items
        // with the first and last ones being line breaks.
        //
        // However this did not occur when testing with live data from NextCloud
        // that is why we'll continue with next child if trimmed value is empty.
        // If a non-empty text child occurs, its value will be returned instead.
        //
        // If no child occurs it will return an empty value
        // Note that if a non-XmlText item occurs after an empty text value and
        // no XmlText comes after that, the value will be a List of Non-XmlText
        // items
        if (stringReturnValue.trim().isEmpty) {
          continue;
        }
        return stringReturnValue;
      }

      var childAsElement = child as XmlElement;
      var name = childAsElement.name.local;
      var namespaceUri = childAsElement.name.namespaceUri;
      try {
        var subParser = ParserFactory.create().getParser(name, namespaceUri);
        var parsedValue = subParser.parseSingle(child);
        if (parsedValue is String) {
          return parsedValue;
        } else {
          propList.add(parsedValue);
        }
        // ignore: avoid_catching_errors
      } on StateError catch (_) {
        if (!skipUnparsableChildren) {
          throw UnimplementedError("Missing processor for node $name "
              "in namespace $namespaceUri");
        }
      }
    }
    return propList;
  }
}
