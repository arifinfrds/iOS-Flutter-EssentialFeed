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
    final client = TransactionStoreSpy();
    final sut = LocalTransactionLoader(client);

    expect(client.requestCallCount, 0);
  });

  test("test_load_requestLoadTransactions", () {
    final client = TransactionStoreSpy();
    final sut = LocalTransactionLoader(client);

    sut.load();

    expect(client.requestCallCount, 1);
  });
}

class TransactionStoreSpy with TransactionStore {
  int requestCallCount = 0;

  @override
  void loadTransactions() {
    requestCallCount += 1;
  }
}