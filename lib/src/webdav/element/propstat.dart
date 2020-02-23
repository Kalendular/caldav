import 'package:xml/xml.dart';
// ignore: implementation_imports
import 'package:xml/src/xml/utils/node_list.dart';
import '../webdav_element.dart';
import '../webdav_parser.dart';
import 'prop.dart';
import 'status.dart';

/// <propstat> element described in RFC 4918
class WebDavPropStat extends WebDavElement {
  WebDavStatus status;

  List<WebDavProp> props = [];

  /// The propstat XML element MUST contain
  /// one prop XML element and one status XML element.
  WebDavPropStat(WebDavProp prop, this.status) : super('propstat') {
    addProp(prop);
  }

  List<WebDavProp> getProps() {
    return props;
  }

  void addProp(WebDavProp prop) {
    props.add(prop);
  }
}

class PropStatParser extends WebDavParser<WebDavPropStat> {
  PropParser propParser = PropParser();
  StatusParser statusParser = StatusParser();

  @override
  WebDavPropStat getGenericInstance() => WebDavPropStat(null, null);

  @override
  WebDavPropStat parseSingle(XmlNode node) {
    var propStat = node as XmlElement;

    // parse properties and status
    var props = propParser.parse(propStat);
    var propStatObj =
        WebDavPropStat(props.elementAt(0), statusParser.parse(node).first);
    propStatObj.props = props;

    return propStatObj;
  }

  /// No parsing required. Children are processed in [parseSingle]
  @override
  dynamic parseChildren(XmlNodeList<XmlNode> children) {}
}
