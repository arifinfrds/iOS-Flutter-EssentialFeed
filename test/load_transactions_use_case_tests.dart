import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:simple_result/simple_result.dart';
import 'package:transactions/Feature/LocalTransactionLoader.dart';
import 'package:transactions/Feature/Transaction.dart';
import 'package:transactions/Store/TransactionStore.dart';
import 'package:tuple/tuple.dart';

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

    expect(store.messages, [TransactionStoreSpyMessage.load, TransactionStoreSpyMessage.load]);
  });

  test("test_load_deliversErrorOnLoadTransactionsError", () async {
    final expectedError = TransactionStoreUnknownException();
    final store = TransactionStoreStub(Result.failure(expectedError));
    final sut = LocalTransactionLoader(store);

    final result = sut.load();
    result
        .then((value) => () {
              assert(false, "Expect failure, got : " + value.toString());
            })
        .catchError((error) {
      expect(error, TransactionStoreUnknownException);
    });
  });

  test("test_load_succeedsWithEmptyTransactions", () {
    final store = TransactionStoreStub(Result.success([]));
    final sut = LocalTransactionLoader(store);

    final result = sut.load();
    result
        .then((value) => () {
              value.when(success: (transactions) {
                expect(transactions.isEmpty, true);
              }, failure: (error) {
                assert(false, "Expect to complete with success, got " + error.toString() + "instead.");
              });
            })
        .catchError((error) {
      assert(false, "Expect to complete with success, got " + error + "instead.");
    });
  });

  test("test_load_succeedsWithTransactions", () {
    final expectedTransactions = [Transaction(), Transaction()];
    final store = TransactionStoreStub(Result.success(expectedTransactions));
    final sut = LocalTransactionLoader(store);

    final result = sut.load();
    result
        .then((value) => () {
              value.when(success: (transactions) {
                expect(transactions, expectedTransactions);
              }, failure: (error) {
                assert(false, "Expect to complete with success, got " + error.toString() + "instead.");
              });
            })
        .catchError((error) {
      assert(false, "Expect to complete with success, got " + error + "instead.");
    });
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
  Future<Result<List<Transaction>, Exception>> loadTransactions() {
    messages.add(TransactionStoreSpyMessage.load);
    return Future.value(Result.success([]));
  }
}

// MARK: - Helpers

class TransactionStoreStub implements TransactionStore {
  Result<List<Transaction>, Exception> _result = Result.success([]);

  TransactionStoreStub(this._result);

  @override
  Future<Result<List<Transaction>, Exception>> loadTransactions() {
    return Future.value(_result);
  }
}

enum TransactionStoreSpyMessage { load }
