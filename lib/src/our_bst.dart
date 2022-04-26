import 'ordered_our_st.dart';

class BstNode<K, V> {
  final K _key;
  V _val;
  BstNode<K, V>? _left, _right;
  int _subtreeSize;

  BstNode(this._key, this._val, this._left, this._right, this._subtreeSize);
}

class OurBst<K extends Comparable<K>, V> implements OrderedOurST<K, V> {
  BstNode<K, V>? _root;

  @override
  bool contains(key) => get(key) != null;

  @override
  void delete(key) {
    if (!contains(key)) throw UnsupportedError("ST doesn't contain key '$key'");
    _root = _delete(_root!, key);
  }

  BstNode<K, V>? _delete(BstNode<K, V> node, K key) {
    var x = key.compareTo(node._key);
    if (x < 0) {
      node._left = _delete(node._left!, key);
    } else if (x > 0) {
      node._right = _delete(node._right!, key);
    } else {
      if (node._left == null) return node._right;
      if (node._right == null) return node._left;
      var t = node;
      //TODO: make symetric
      node = _min(node._right!);
      node._right = _deleteMin(node._right!);
      node._left = t._left;
    }
    node._subtreeSize = _size(node._left) + _size(node._right) + 1;
    return node;
  }

  @override
  void deleteMax() {
    if (isEmpty) throw UnsupportedError("There's nothing to delete");
    _root = _deleteMax(_root!);
  }

  @override
  void deleteMin() {
    if (isEmpty) throw UnsupportedError("There's nothing to delete");
    _root = _deleteMin(_root!);
  }

  BstNode<K, V>? _deleteMax(BstNode<K, V> node) {
    if (node._right == null) return node._left;
    node._right = _deleteMax(node._right!);
    node._subtreeSize = _size(node._left) + _size(node._right) + 1;
    return node;
  }

  BstNode<K, V>? _deleteMin(BstNode<K, V> node) {
    if (node._left == null) return node._right;
    node._left = _deleteMax(node._left!);
    node._subtreeSize = _size(node._left) + _size(node._right) + 1;
    return node;
  }

  @override
  K? ceiling(K key) {
    BstNode<K, V>? node = _ceiling(_root, key);
    return node == null
        ? throw UnsupportedError("There's no ceiling for key '$key'")
        : node._key;
  }

  @override
  K? floor(K key) {
    BstNode<K, V>? node = _floor(_root, key);
    return node == null
        ? throw UnsupportedError("There's no floor for key '$key'")
        : node._key;
  }

  BstNode<K, V>? _ceiling(BstNode<K, V>? node, K key) {
    if (node == null) return null;
    var x = key.compareTo(node._key);
    if (x == 0) return node;
    if (x > 0) return _ceiling(node._right, key);
    var n = _ceiling(node._left, key);
    return n ?? node;
  }

  BstNode<K, V>? _floor(BstNode<K, V>? node, K key) {
    if (node == null) return null;
    var x = key.compareTo(node._key);
    if (x == 0) return node;
    if (x < 0) return _floor(node._left, key);
    var n = _floor(node._right, key);
    return n ?? node;
  }

  @override
  V? get(K key) => _get(_root, key)?._val;

  BstNode<K, V>? _get(BstNode<K, V>? node, K key) {
    if (node == null) return null;
    var x = key.compareTo(node._key);
    if (x < 0) return _get(node._left, key);
    if (x > 0) return _get(node._right, key);
    return node;
  }

  @override
  bool get isEmpty => size == 0;

  @override
  Iterable<K> get keys {
    var list = <K>[];
    if (!isEmpty) _keysBetween(list, _root, min, max);
    return list;
  }

  @override
  Iterable<K> keysBetween(K lo, K hi) {
    var list = <K>[];
    _keysBetween(list, _root, lo, hi);
    return list;
  }

  void _keysBetween(List<K> list, BstNode<K, V>? node, K lo, K hi) {
    if (node == null) return;
    var cmpLo = lo.compareTo(node._key);
    var cmpHi = hi.compareTo(node._key);
    if (cmpLo < 0) _keysBetween(list, node._left, lo, hi);
    if (cmpLo <= 0 && cmpHi >= 0) list.add(node._key);
    if (cmpHi > 0) _keysBetween(list, node._right, lo, hi);
  }

  @override
  K get max => isEmpty
      ? throw UnsupportedError("Can't get the max from an empty bst")
      : _max(_root!)._key;

  @override
  K get min => isEmpty
      ? throw UnsupportedError("Can't get the min from an empty bst")
      : _min(_root!)._key;

  BstNode<K, V> _max(BstNode<K, V> node) =>
      node._right == null ? node : _max(node._right!);

  BstNode<K, V> _min(BstNode<K, V> node) =>
      node._left == null ? node : _min(node._left!);

  @override
  void put(key, val) {
    _root = _put(_root, key, val);
  }

  _put(BstNode<K, V>? node, K key, V val) {
    if (node == null) return BstNode<K, V>(key, val, null, null, 1);
    var x = key.compareTo(node._key);
    if (x < 0) {
      node._left = _put(node._left, key, val);
    } else if (x > 0) {
      node._right = _put(node._right, key, val);
    } else {
      node._val = val;
    }
    node._subtreeSize = _size(node._left) + _size(node._right) + 1;
    return node;
  }

  @override
  int rank(K key) => _rank(_root, key);

  int _rank(BstNode<K, V>? node, K key) {
    if (node == null) return 0;
    var x = key.compareTo(node._key);
    if (x < 0) return _rank(node._left, key);
    if (x > 0) return _rank(node._right, key) + _size(node._left) + 1;
    return _size(node._left);
  }

  @override
  K select(int keyRank) {
    if (keyRank < 0 || keyRank >= size) {
      throw ArgumentError("Invalid keyRank '$keyRank' for selection");
    }
    return _select(_root!, keyRank);
  }

  K _select(BstNode<K, V> node, int keyRank) {
    var rank = _size(node._left);
    if (keyRank > rank) return _select(node._right!, keyRank - (rank + 1));
    if (keyRank < rank) return _select(node._left!, keyRank);
    return node._key;
  }

  @override
  int get size => _size(_root);

  int _size(BstNode<K, V>? node) => node?._subtreeSize ?? 0;

  @override
  int sizeBetween(K lo, K hi) {
    // TODO: implement sizeBetween
    throw UnimplementedError();
  }
}
