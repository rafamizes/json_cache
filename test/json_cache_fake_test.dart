import 'package:flutter_test/flutter_test.dart';
import 'package:json_cache/json_cache.dart';

void main() {
  group('JsonCacheFake:', () {
    const profKey = 'profile';
    const prefKey = 'preferences';
    const profData = <String, dynamic>{'id': 1, 'name': 'John Due'};
    const prefData = <String, dynamic>{
      'theme': 'dark',
      'notifications': {'enabled': true},
    };
    const data = <String, Map<String, dynamic>?>{
      profKey: profData,
      prefKey: prefData,
    };

    group('clear', () {
      test('default ctor', () async {
        final JsonCacheFake fakeCache = JsonCacheFake();
        await fakeCache.refresh(profKey, profData);
        await fakeCache.refresh(prefKey, prefData);
        await fakeCache.clear();
        final cachedProf = await fakeCache.value(profKey);
        expect(cachedProf, isNull);
        final cachedPref = await fakeCache.value(prefKey);
        expect(cachedPref, isNull);
      });
      test('init ctor', () async {
        final JsonCacheFake initMemCache = JsonCacheFake.init(data);
        await initMemCache.refresh(profKey, profData);
        await initMemCache.refresh(prefKey, prefData);
        await initMemCache.clear();
        final cachedProf = await initMemCache.value(profKey);
        expect(cachedProf, isNull);
        final cachedPref = await initMemCache.value(prefKey);
        expect(cachedPref, isNull);
      });
      test('mem ctor', () async {
        final copy = Map<String, Map<String, dynamic>?>.of(data);
        final JsonCacheFake memCache = JsonCacheFake.mem(copy);
        await memCache.clear();

        final cachedProf = await memCache.value(profKey);
        expect(cachedProf, isNull);

        final cachedPref = await memCache.value(prefKey);
        expect(cachedPref, isNull);

        expect(copy.isEmpty, true);
      });
    });

    test('contains', () async {
      final fake = JsonCacheFake();
      // update data
      await fake.refresh(profKey, profData);
      await fake.refresh(prefKey, prefData);

      // test for `true`
      expect(await fake.contains(profKey), true);
      expect(await fake.contains(prefKey), true);

      await fake.remove(prefKey);
      expect(await fake.contains(prefKey), false);
      expect(await fake.contains('a key'), false);
    });
    group('method "keys"', () {
      late JsonCacheFake fakeCache;
      setUp(() async {
        fakeCache = JsonCacheFake();
        // update data
        await fakeCache.refresh(profKey, profData);
        await fakeCache.refresh(prefKey, prefData);
      });
      test('should return the inserted keys', () async {
        expect(await fakeCache.keys(), [profKey, prefKey]);
      });
      test('should keep the returned keys immutable', () async {
        final keys = await fakeCache.keys();
        // This should not change the 'keys' variable.
        await fakeCache
            .refresh('info', {'This is very important information.': true});
        expect(keys, [profKey, prefKey]);
      });
    });
    group('remove', () {
      test('default ctor', () async {
        final JsonCacheFake fakeCache = JsonCacheFake();
        await fakeCache.refresh(profKey, profData);
        await fakeCache.refresh(prefKey, prefData);
        await fakeCache.remove(profKey);
        final cachedProf = await fakeCache.value(profKey);
        expect(cachedProf, isNull);
        await fakeCache.remove(prefKey);
        final cachedPref = await fakeCache.value(prefKey);
        expect(cachedPref, isNull);
      });
      test('init ctor', () async {
        final JsonCacheFake initMemCache = JsonCacheFake.init(data);
        await initMemCache.refresh(profKey, profData);
        await initMemCache.refresh(prefKey, prefData);

        await initMemCache.remove(profKey);
        final cachedProf = await initMemCache.value(profKey);
        expect(cachedProf, isNull);

        await initMemCache.remove(prefKey);
        final cachedPref = await initMemCache.value(prefKey);
        expect(cachedPref, isNull);
      });
      test('mem ctor', () async {
        final copy = Map<String, Map<String, dynamic>?>.of(data);
        final JsonCacheFake fakeCache = JsonCacheFake.mem(copy);
        await fakeCache.refresh(profKey, profData);
        await fakeCache.refresh(prefKey, prefData);

        await fakeCache.remove(profKey);
        final cachedProf = await fakeCache.value(profKey);
        expect(cachedProf, isNull);

        await fakeCache.remove(prefKey);
        final cachedPref = await fakeCache.value(prefKey);
        expect(cachedPref, isNull);
      });
    });
    group('refresh and value', () {
      test('default ctor', () async {
        final JsonCacheFake fakeCache = JsonCacheFake();
        await fakeCache.refresh(profKey, profData);
        await fakeCache.refresh(prefKey, prefData);

        final cachedProf = await fakeCache.value(profKey);
        expect(cachedProf, profData);

        final cachedPref = await fakeCache.value(prefKey);
        expect(cachedPref, prefData);
      });
      test('init ctor', () async {
        final JsonCacheFake initMemCache = JsonCacheFake.init(data);
        await initMemCache.refresh(profKey, profData);
        await initMemCache.refresh(prefKey, prefData);

        final cachedProf = await initMemCache.value(profKey);
        expect(cachedProf, profData);

        final cachedPref = await initMemCache.value(prefKey);
        expect(cachedPref, prefData);
      });
      test('mem ctor', () async {
        final mem = <String, Map<String, dynamic>?>{};
        final JsonCacheFake fakeCache = JsonCacheFake.mem(mem);
        await fakeCache.refresh(profKey, profData);
        await fakeCache.refresh(prefKey, prefData);

        final cachedProf = await fakeCache.value(profKey);
        expect(cachedProf, profData);

        final cachedPref = await fakeCache.value(prefKey);
        expect(cachedPref, prefData);
        expect(mem[profKey], profData);
        expect(mem[prefKey], prefData);
      });
    });
  });
}
