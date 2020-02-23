/// Provides useful functionality for String manipulation
class StringUtility {
  /// Removes API base path and leading and trailing slash of path string
  static String sanitizePath(String path, {String baseUrl = ''}) {
    if (path.startsWith('/')) {
      path = path.substring(1);
    }
    if (path.startsWith(baseUrl)) {
      path = path.substring(baseUrl.length);
    }
    if (path.startsWith('/')) {
      path = path.substring(1);
    }
    if (path.endsWith('/')) {
      path = path.substring(0, path.length - 1);
    }
    return path;
  }

  /// Concatenates [apiBase] and [remotePath] into a path
  static String getFullPath(String apiBase, String remotePath) {
    remotePath = StringUtility.sanitizePath(remotePath);
    if (remotePath.isNotEmpty) {
      return '/$apiBase/$remotePath/';
    }
    return '/$apiBase/';
  }
}
