import 'package:simple_result/simple_result.dart';
import 'package:transactions/Feature/Transaction.dart';

abstract class TransactionStore {
  Future<Result<List<Transaction>, Exception>> loadTransactions();
}

class TransactionStoreException implements Exception {}

class TransactionStoreUnknownException extends TransactionStoreException {}
