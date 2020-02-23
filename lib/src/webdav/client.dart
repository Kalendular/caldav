import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'package:http_auth/http_auth.dart' as http_auth;
import '../core/utility/string.dart';
import '../core/xmlelement.dart';
import 'element/_elements.dart';
import 'response.dart';

/// Interacts with WebDAV server
class WebDavClient {
  /// [host] is the host address, e.g. calendar.saitho.me or 192.168.0.1
  String host;

  /// [port] is the port that should be used
  int port;

  /// [username] is the username for login
  String username;

  /// [password] is the password for login
  String password;

  /// [protocol] is the protocol to be used
  String protocol = 'http';

  /// [path] is the path to CalDAV API
  String path;

  /// [concreteClient] HTTP client that executes request
  http_auth.BasicAuthClient concreteClient;

  /// Constructor for WebDAV client
  WebDavClient(this.host, this.username, this.password, this.path,
      {this.protocol, this.port, http.BaseClient httpClient}) {
    concreteClient =
        http_auth.BasicAuthClient(username, password, inner: httpClient);
  }

  /// baseUrl for API requests
  String get baseUrl {
    var baseUrl = "$protocol://$host";
    if (port != null) {
      baseUrl = "$protocol://$host:$port";
    }

    // BaseURL must not end with /
    if (baseUrl.endsWith('"')) {
      baseUrl = baseUrl.substring(0, baseUrl.length - 1);
    }

    if (path.isNotEmpty && path != '"') {
      baseUrl = [baseUrl, path].join('/');
    }
    return baseUrl;
  }

  String _getRequestUrl(String path) {
    path = path.trim();

    if (path.startsWith('/')) {
      path = path.substring(1, path.length);
    }

    return [baseUrl, path].join('/');
  }

  /// Perform a PUT request to [remotePath] with optional [body] and [headers]
  Future<http.Response> put(String remotePath,
      {String body, Map<String, String> headers}) async {
    remotePath = StringUtility.sanitizePath(remotePath, baseUrl: path);
    return _send('PUT', remotePath, headers: headers, body: body);
  }

  /// Perform a PROPFIND request to [remotePath] with an optional [body]
  Future<Response> propfind(String remotePath, {String body}) async {
    remotePath = StringUtility.sanitizePath(remotePath, baseUrl: path);
    var userHeader = {'Depth': '1'};
    var response =
        await _send('PROPFIND', remotePath, headers: userHeader, body: body);

    return Response(response, remotePath, path);
  }

  /// send the actual HTTP request with given [method] and [path]
  Future<http.Response> _send(String method, String path,
      {String body, Map<String, String> headers}) async {
    var url = _getRequestUrl(path);
    var request = http.Request(method, Uri.parse(url));

    if (headers != null) request.headers.addAll(headers);
    if (body != null) {
      request.body = body;
    }

    developer.log("Connecting to $url");
    var response =
        await http.Response.fromStream(await concreteClient.send(request));
    if (response.statusCode == 301) {
      return _send(method, response.headers['location'],
          body: body, headers: headers);
    }
    return response;
  }

  /// Find a property [T] within propstat > prop of a given [response]
  T findProperty<T extends XmlElement>(WebDavResponse response, T property) {
    for (var propStat in response.propStats) {
      for (var prop in propStat.props) {
        for (var content in prop.content) {
          if (content == property) {
            return content as T;
          }
        }
      }
    }
    return null;
  }
}
