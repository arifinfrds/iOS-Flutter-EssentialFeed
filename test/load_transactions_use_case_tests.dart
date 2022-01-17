import 'dart:ffi';

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

    expect(store.messages.isEmpty, true);
  });

  test("test_load_requestLoadTransactions", () {
    final tuple = _makeSUT();
    final sut = tuple.item1;
    final store = tuple.item2;

    sut.load();

    expect(store.messages, [TransactionStoreSpyMessage.load]);
  });

  test("test_loadTwice_requestLoadTransactionsTwice", () {
    final tuple = _makeSUT();
    final sut = tuple.item1;
    final store = tuple.item2;

    sut.load();
    sut.load();

    expect(store.messages,
        [TransactionStoreSpyMessage.load, TransactionStoreSpyMessage.load]);
  });
}

Tuple2<LocalTransactionLoader, TransactionStoreSpy> _makeSUT() {
  final store = TransactionStoreSpy();
  final sut = LocalTransactionLoader(store);
  return Tuple2(sut, store);
}

class TransactionStoreSpy implements TransactionStore {
  List<TransactionStoreSpyMessage> messages = [];

  @override
  void loadTransactions() {
    messages.add(TransactionStoreSpyMessage.load);
  }
}

enum TransactionStoreSpyMessage { load }
