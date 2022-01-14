import 'package:flutter_test/flutter_test.dart';

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
    final store = TransactionStoreSpy();
    final sut = LocalTransactionLoader(store);

    expect(store.requestCallCount, 0);
  });

  test("test_load_requestLoadTransactions", () {
    final store = TransactionStoreSpy();
    final sut = LocalTransactionLoader(store);

    sut.load();

    expect(store.requestCallCount, 1);
  });

  test("test_loadTwice_requestLoadTransactionsTwice", () {
    final store = TransactionStoreSpy();
    final sut = LocalTransactionLoader(store);

    sut.load();
    sut.load();

    expect(store.requestCallCount, 2);
  });
}

class TransactionStoreSpy with TransactionStore {
  int requestCallCount = 0;

  @override
  void loadTransactions() {
    requestCallCount += 1;
  }
}