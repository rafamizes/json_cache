import 'package:flutter_test/flutter_test.dart';
import 'package:json_cache/json_cache.dart';

import 'fake_local_storage.dart';

void main() {
  group('JsonCacheLocalStorage', () {
    const profKey = 'profile';
    const profData = <String, Object>{'id': 1, 'name': 'John Due'};
    const prefData = <String, dynamic>{
      'theme': 'dark',
      'notifications': {'enabled': true},
    };
    test('clear, recover and refresh', () async {
      final JsonCacheLocalStorage jsonCache = _fakeInstance;
      await jsonCache.refresh(profKey, profData);
      var prof = await jsonCache.value(profKey);
      expect(prof, profData);
      await jsonCache.clear();
      prof = await jsonCache.value(profKey);
      expect(prof, isNull);
    });

    test('contains', () async {
      const prefKey = 'preferences';
      final JsonCacheLocalStorage jsonCache = _fakeInstance;
      // update data
      await jsonCache.refresh(profKey, profData);
      await jsonCache.refresh(prefKey, prefData);

      // test for `true`
      expect(await jsonCache.contains(profKey), true);
      expect(await jsonCache.contains(prefKey), true);

      // test for `false`
      expect(await jsonCache.contains('a key'), false);
      await jsonCache.remove(profKey);
      expect(await jsonCache.contains(profKey), false);
      await jsonCache.remove(prefKey);
      expect(await jsonCache.contains(prefKey), false);
    });

    test('keys', () async {
      const prefKey = 'preferences';
      final JsonCacheLocalStorage jsonCache = _fakeInstance;
      // update data
      await jsonCache.refresh(profKey, profData);
      await jsonCache.refresh(prefKey, prefData);

      expect(await jsonCache.keys(), [profKey, prefKey]);
    });
    test('remove', () async {
      const prefKey = 'preferences';
      final JsonCacheLocalStorage jsonCache = _fakeInstance;
      await jsonCache.refresh(profKey, profData);
      await jsonCache.refresh(prefKey, prefData);

      var prof = await jsonCache.value(profKey);
      expect(prof, profData);

      await jsonCache.remove(profKey);
      prof = await jsonCache.value(profKey);
      expect(prof, isNull);

      var pref = await jsonCache.value(prefKey);
      expect(pref, prefData);
      await jsonCache.remove(prefKey);
      pref = await jsonCache.value(prefKey);
      expect(pref, isNull);
    });
  });
}

/// Helper factory getter.
JsonCacheLocalStorage get _fakeInstance {
  return JsonCacheLocalStorage(FakeLocalStorage());
}
