class CacheEntry {
  Object data;
  DateTime addDate;
  
  CacheEntry(Object data) {
    this.data = data;
    this.addDate = DateTime.now();
  }
}
class Cache {
  static var _cache = new Map<String, CacheEntry>();
  static final _expirationDuration = Duration(minutes: 5);

  static get(String key){
    var cacheEntry = _cache[key];
    if (cacheEntry != null && DateTime.now().difference(cacheEntry.addDate) <= _expirationDuration) {
      print('LOG: getting ' + key + ' from cache');
      return cacheEntry.data;
    }
    return null;
  }

  static void add(String key, Object data) {
    _cache[key] = new CacheEntry(data);
  }

  static void remove(String key) {
    _cache.remove(key);
  }
}