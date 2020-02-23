import '../event_repository.dart';
import 'client.dart';

/// internal object representing a CalDav calendar
class CalDavCalendar {
  /// path to calendar
  String path;

  /// name of calendar
  String displayName;

  /// CalDav Client instance to be used
  final CalDavClient _client;

  /// Constructor
  CalDavCalendar(this.path, this.displayName, this._client);

  @override
  String toString() {
    return '$displayName (path: $path)';
  }

  /// Returns the [EventRepository] for this calendar
  EventRepository getEventRepository() {
    return EventRepository(path, _client);
  }
}
