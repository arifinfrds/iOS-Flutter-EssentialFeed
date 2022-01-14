import 'package:flutter_test/flutter_test.dart';
import 'package:tuple/tuple.dart';

mixin TransactionStore {
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
    final tuple = makeSUT();
    final store = tuple.item2;

    expect(store.requestCallCount, 0);
  });

  test("test_load_requestLoadTransactions", () {
    final tuple = makeSUT();
    final sut = tuple.item1;
    final store = tuple.item2;

    sut.load();

    expect(store.requestCallCount, 1);
  });

  test("test_loadTwice_requestLoadTransactionsTwice", () {
    final tuple = makeSUT();
    final sut = tuple.item1;
    final store = tuple.item2;

    sut.load();
    sut.load();

    expect(store.requestCallCount, 2);
  });
}

Tuple2<LocalTransactionLoader, TransactionStoreSpy> makeSUT() {
  final store = TransactionStoreSpy();
  final sut = LocalTransactionLoader(store);
  return Tuple2(sut, store);
}

class TransactionStoreSpy with TransactionStore {
  int requestCallCount = 0;

  @override
  void loadTransactions() {
    requestCallCount += 1;
  }
}