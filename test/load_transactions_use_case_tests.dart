

import 'package:flutter_test/flutter_test.dart';
import 'package:simple_result/simple_result.dart';
import 'package:tuple/tuple.dart';

class Transaction { }

abstract class TransactionStore {
  Result<List<Transaction>, TransactionLoaderError> loadTransactions();
}

class LocalTransactionLoader {
  TransactionStore store;

  LocalTransactionLoader(this.store);

  Result<List<Transaction>, TransactionLoaderError> load() {
    Result result = store.loadTransactions();
    return result.when(success: (transactions) {
      return Result.success(transactions);
    } , failure: (error) {
      return Result.failure(error);
    });
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

  test("test_load_deliversNotFoundErrorOnNotFoundTransaction", () {
    final expectedError = TransactionLoaderError.notFound;
    final store = TransactionStoreStub(Result.failure(expectedError));
    final sut = LocalTransactionLoader(store);
    List<TransactionLoaderError> capturedErrors = [];

    final result = sut.load();
    result.when(success: (transactions) {
      assert(false, "Expect failure, got transactions instead with items: " + transactions.toString());
    }, failure: (error) {
      capturedErrors.add(error);
    });

    expect(capturedErrors, [ TransactionLoaderError.notFound ]);
  });
  
  test("test_load_succeedsWithEmptyTransactions", () {
    final store = TransactionStoreStub(Result.success([]));
    final sut = LocalTransactionLoader(store);

    final result = sut.load();

    result.when(success: (transactions) {
      expect(transactions.isEmpty, true);
    }, failure: (error) {
      assert(false, "Expect to complete with success, got " + error.toString() + "instead.");
    });
  });

  test("test_load_succedsWithTransactions", () {
    final expectedTransactions = [Transaction(), Transaction()];
    final store = TransactionStoreStub(Result.success(expectedTransactions));
    final sut = LocalTransactionLoader(store);

    final result = sut.load();

    result.when(success: (transactions) {
      expect(transactions, expectedTransactions);
    }, failure: (error) {
      assert(false, "Expect to complete with success, got " + error.toString() + "instead.");
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
  Result<List<Transaction>, TransactionLoaderError> loadTransactions() {
    messages.add(TransactionStoreSpyMessage.load);
    return Result.success([]);
  }
}

class TransactionStoreStub implements TransactionStore {
  Result<List<Transaction>, TransactionLoaderError> _result = Result.success([]);

  TransactionStoreStub(this._result);

  @override
  Result<List<Transaction>, TransactionLoaderError> loadTransactions() {
    return _result;
  }
}

enum TransactionStoreSpyMessage { load }

enum TransactionLoaderError {
  notFound,
  unknown
}
