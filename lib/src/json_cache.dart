import 'dart:collection';

/// Represents cached data in json format.
///
///> "Cache is a hardware or software component that stores data so that future
///>  requests for that data can be served faster; the data stored in a cache
///>  might be the result of an earlier computation or a copy of data stored
///>  elsewhere."
///> — [cache Wikipedia](https://en.wikipedia.org/wiki/Cache_(computing))
abstract interface class JsonCache {
  /// Frees up storage space — deletes all keys and values.
  Future<void> clear();

  /// Removes the cached data located at [key].
  Future<void> remove(String key);

  /// Retrieves the data located at [key] or `null` if a cache miss occurs.
  Future<Map<String, dynamic>?> value(String key);

  /// It either updates the data found at [key] with [value] or, if there is no
  /// previous data at [key], creates a new cache line at [key] with [value].
  ///
  /// **Note**: [value] must be json encodable.
  Future<void> refresh(String key, Map<String, dynamic> value);

  /// Checks for cached data at [key].
  ///
  /// Returns `true` if there is cached data at [key]; `false` otherwise.
  Future<bool> contains(String key);

  /// The cache keys.
  ///
  /// Returns an **unmodifiable** list of all cache keys without duplicates.
  Future<UnmodifiableListView<String>> keys();
}
