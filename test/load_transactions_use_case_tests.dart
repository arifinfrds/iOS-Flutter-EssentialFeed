import 'package:flutter_test/flutter_test.dart';

mixin TransactionStore {}

class LocalTransactionLoader {
  TransactionStore store;

  LocalTransactionLoader(this.store);
}

void main() {
  test("test_init_doesNotLoadAnyTransactions", () {
    final client = TransactionStoreSpy();
    final sut = LocalTransactionLoader(client);

    expect(client.requestCallCount, 0);
  });
}

class TransactionStoreSpy with TransactionStore {
  int requestCallCount = 0;
}