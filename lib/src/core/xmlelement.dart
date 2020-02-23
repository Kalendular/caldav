import 'package:xml/xml.dart' as xml;
import 'package:quiver/core.dart';

/// For XmlNode-based objects
class XmlElement {
  /// Name of XML element
  String name;

  /// Namespace of XML element (not short code)
  String namespace;

  /// Constructs a new XmlElement
  XmlElement({this.name, this.namespace});

  /// Creates an XmlElement off a XmlNode from xml package
  factory XmlElement.fromXmlNode(xml.XmlNode node) {
    var element = node as xml.XmlElement;
    return XmlElement(
        name: element.name.local, namespace: element.name.namespaceUri);
  }

  @override
  String toString() {
    return 'XmlElement{name: $name, namespace: $namespace}';
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes, type_annotate_public_apis
  bool operator ==(o) =>
      o is XmlElement && name == o.name && namespace == o.namespace;

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => hash2(name.hashCode, namespace.hashCode);
}
