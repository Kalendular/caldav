import '../core/xmlelement.dart';

/// Namespace of WebDAV elements
const webDavNamespace = 'DAV:';

/// Base class for WebDav elements
class WebDavElement extends XmlElement {
  /// Constructor for WebDAV elements
  WebDavElement(String name) {
    this.name = name;
    namespace = webDavNamespace;
  }
}
