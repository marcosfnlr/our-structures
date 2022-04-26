abstract class OurST<K, V> {
  void put(K key, V val);
  V? get(K key);
  void delete(K key);
  bool contains(K key);
  bool get isEmpty;
  int get size;
  Iterable<K> get keys;
}
