import 'package:flutter_test/flutter_test.dart';
import 'package:tuple/tuple.dart';

abstract class TransactionStore {
  void loadTransactions();
}

class LocalTransactionLoader {
  TransactionStore store;

  LocalTransactionLoader(this.store);

  void load() {
    store.loadTransactions();
  }
}

void main() {
  test("test_init_doesNotLoadAnyTransactions", () {
    final tuple = _makeSUT();
    final store = tuple.item2;

    expect(store.requestCallCount, 0);
  });

  test("test_load_requestLoadTransactions", () {
    final tuple = _makeSUT();
    final sut = tuple.item1;
    final store = tuple.item2;

    sut.load();

    expect(store.requestCallCount, 1);
  });

  test("test_loadTwice_requestLoadTransactionsTwice", () {
    final tuple = _makeSUT();
    final sut = tuple.item1;
    final store = tuple.item2;

    sut.load();
    sut.load();

    expect(store.requestCallCount, 2);
  });
}

Tuple2<LocalTransactionLoader, TransactionStoreSpy> _makeSUT() {
  final store = TransactionStoreSpy();
  final sut = LocalTransactionLoader(store);
  return Tuple2(sut, store);
}

class TransactionStoreSpy implements TransactionStore {
  int requestCallCount = 0;

  @override
  void loadTransactions() {
    requestCallCount += 1;
  }
}