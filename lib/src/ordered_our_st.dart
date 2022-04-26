import 'our_st.dart';

abstract class OrderedOurST<K extends Comparable<K>, V> implements OurST<K, V> {
  K get min;
  K get max;
  K? floor(K key);
  K? ceiling(K key);
  int rank(K key);
  K select(int keyRank);
  void deleteMin();
  void deleteMax();
  int sizeBetween(K lo, K hi);
  Iterable<K> keysBetween(K lo, K hi);
}
