import 'package:simple_result/simple_result.dart';
import 'package:transactions/Store/TransactionStore.dart';

import 'Transaction.dart';

class LocalTransactionLoader {
  TransactionStore store;

  LocalTransactionLoader(this.store);

  Future<Result<List<Transaction>, Exception>> load() async {
    return store.loadTransactions();
  }
}
