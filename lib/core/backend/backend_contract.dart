/// Canonical backend contract shared by every request that can reach the
/// database-backed GERYON API.
///
/// DBVersion is not an optional compatibility hint. The backend uses it to
/// select the active repository implementation. Omitting it causes the Go
/// backend to deserialize the value as 0 and route the request through an
/// obsolete/default contract. Keep this value centralized so widgets and
/// feature models cannot silently drift to different backend generations.
class BackendContract {
  static const String dbVersionKey = 'DBVersion';
  static const int dbVersion = 10;

  const BackendContract._();
}
