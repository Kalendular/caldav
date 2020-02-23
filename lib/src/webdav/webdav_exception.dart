/// Exception thrown when error with WebDav interaction occurs
class WebDavException implements Exception {
  /// Exception message
  String cause;

  /// WebDavException
  WebDavException(this.cause);
}
