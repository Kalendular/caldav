import 'package:xml/xml.dart';
import 'xmlelement.dart' as core;

/// Base for parsers that process [XmlNode] into another data type
/// todo: rename to Mapper
abstract class Parser<T> {
  /// provides an instance of the object that is created.
  T getGenericInstance();

  /// Get node name from instance in [getGenericInstance].
  /// Override this if [T] is not an instance of [core.XmlElement]
  String get nodeName {
    var instance = getGenericInstance();
    if (instance is core.XmlElement) {
      return instance.name;
    }
    return null;
  }

  /// Get node namespace from instance in [getGenericInstance].
  /// Override this if [T] is not an instance of [core.XmlElement]
  String get nodeNamespace {
    var instance = getGenericInstance();
    if (instance is core.XmlElement) {
      return instance.namespace;
    }
    return null;
  }

  String _getFullName() {
    if (!pathToNamespaceMap.containsKey(nodeNamespace)) {
      throw ArgumentError('Unknown namespace path "$nodeNamespace"');
    }
    return '${pathToNamespaceMap[nodeNamespace]}:$nodeName';
  }

  /// maps ns => full/namespace/urn
  Map<String, String> namespaceMap = {};

  /// maps full/namespace/urn => ns
  Map<String, String> pathToNamespaceMap = {};

  /// Updates [namespaceMap] which is used to map XML shortCodes to namespace
  void updateNamespaces(XmlNode node) {
    var xmlAttributes = _collectParentAttributes(node);
    // todo: consider global xmlns as well
    var re = RegExp(r'xmlns:(\w+)="([\w\W]+)"');
    xmlAttributes
        .removeWhere((attribute) => !re.hasMatch(attribute.toString()));

    namespaceMap = {};
    for (var attribute in xmlAttributes) {
      re.allMatches(attribute.toString()).forEach((match) {
        var name = match.group(1);
        var path = match.group(2);
        namespaceMap[name] = path;
        pathToNamespaceMap[path] = name;
      });
    }
  }

  /// Collects attributes from parent nodes
  List<XmlAttribute> _collectParentAttributes(XmlNode node) {
    // ignore: prefer_collection_literals
    var attributes = List<XmlAttribute>();

    // If node is XMlDocument take attributes from rootElement
    if (node is XmlDocument) {
      node = (node as XmlDocument).rootElement;
    }

    attributes.addAll(node.attributes);

    if (node.hasParent && !(node.parent is XmlDocument)) {
      var parentAttributes = _collectParentAttributes(node.parent);
      parentAttributes
          .removeWhere((attribute) => attributes.indexOf(attribute) != -1);
      attributes.addAll(parentAttributes);
    }
    return attributes;
  }

  /// Look for processable nodes in [node] and process them
  List<T> parse(XmlNode node) {
    if (node is XmlDocument) {
      node = (node as XmlDocument).rootElement;
    }
    updateNamespaces(node);
    // ignore: prefer_collection_literals
    var list = List<T>();

    (node as XmlElement).findAllElements(_getFullName()).forEach((element) {
      list.add(parseSingle(element));
    });

    return list;
  }

  /// Processes a single [node]
  T parseSingle(XmlNode node);
}
