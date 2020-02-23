import 'package:xml/xml.dart' as xml;
import 'package:http/http.dart' as http;
import '../core/utility/string.dart';
import 'element/response.dart';

/// Internal object to serve WebDav responses. Not RFC related.
class Response {
  /// Request path in http://[baseurl]/[apiPath]/[requestpath], e.g. "calendar" in http://baseurl.com/api/calendar
  String requestPath;

  /// apiPath in http://[baseurl]/[apiPath]/[requestPath], e.g. "api" in http://baseurl.com/api/calendar
  String requestApiPath;

  /// Response object from http package
  http.Response rawResponse;

  /// XML body as string
  String rawBody;

  /// List of response objects parsed from XML response
  List<WebDavResponse> responses;

  /// Constructor
  Response(this.rawResponse, this.requestPath, this.requestApiPath) {
    rawBody = rawResponse.body;
    var xmlDocument = xml.parse(rawBody);
    responses = ResponseParser().parse(xmlDocument);
  }

  /// Get Response object for a [remotePath]
  WebDavResponse getByPath(String remotePath) {
    return responses.firstWhere((response) =>
        response.getHref() ==
        StringUtility.getFullPath(requestApiPath, remotePath));
  }

  /// Get Response object for the initial request path
  WebDavResponse getByRequestPath() {
    return getByPath(requestPath);
  }

  /// Returns a list of [WebDavResponse] without the initial request's response
  List<WebDavResponse> getResponsesWithoutRequestHref() {
    var responses = this.responses;
    responses.removeWhere((response) =>
        response.getHref() ==
        StringUtility.getFullPath(requestApiPath, requestPath));
    return responses;
  }
}
