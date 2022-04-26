import 'dart:io';

import 'package:our_structures/our_structures.dart';
import 'package:test/test.dart';

void main() {
  group('Bst tests: ', () {
    var st = OurBst<String, int>();
    var keys = <String>{};

    for (var line in File('test/our_nodes.txt').readAsLinesSync()) {
      var l = line.split(',');
      keys.add(l[0]);
      st.put(l[0], int.parse(l[1]));
    }
    var orderedKeys = keys.toList();
    orderedKeys.sort();

    test('getters', () {
      expect(st.isEmpty, isFalse);
      expect(st.size, equals(keys.length));
      expect(st.min, equals(orderedKeys.first));
      expect(st.max, equals(orderedKeys.last));
    });

    test('floor and ceiling', () {
      expect(st.ceiling('banana'), equals('batata'));
      expect(st.ceiling('grace'), equals('grace'));
      expect(st.floor('banana'), equals('b'));
      expect(st.floor('of'), equals('of'));
      expect(() => st.ceiling('z'), throwsUnsupportedError);
      expect(() => st.floor(''), throwsUnsupportedError);
    });

    test('get specific keys', () {
      expect(st.get('batata'), equals(15));
      expect(st.get('links'), equals(-9834));
      expect(st.get('coffee'), equals(21));
    });

    test('contains', () {
      expect(st.contains('this is the worth while fight'), isTrue);
      expect(st.contains('foo'), isFalse);
    });

    test('keys', () {
      int i = 0;
      for (var k in st.keys) {
        expect(k, equals(orderedKeys[i++]));
      }
      expect(i, equals(orderedKeys.length));
      i = 5;
      for (var k in st.keysBetween('d', 'loveisaruthlessgame')) {
        expect(k, equals(orderedKeys[i++]));
      }
    });

    test('delete', () {
      st.delete('is');
      expect(st.contains('is'), isFalse);
      st.deleteMax();
      expect(st.get(st.max), equals(0899523));
      st.deleteMin();
      expect(st.get(st.min), equals(2));
      expect(st.size, equals(16));
    });
  });
}
