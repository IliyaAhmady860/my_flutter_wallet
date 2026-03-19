import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_wallet/services/sqflite_db.dart';
import 'package:my_wallet/models/transaction_model.dart';

final transactionProvider =
    AsyncNotifierProvider<TransactionNotifier, List<TransactionModel>>(() {
      return TransactionNotifier();
    });

class TransactionNotifier extends AsyncNotifier<List<TransactionModel>> {
  int _offset = 0;
  final int _limit = 6;
  bool _hasMore = true;
  bool get hasMore => _hasMore;

  @override
  Future<List<TransactionModel>> build() async {
    final items = await DatabaseHelper.instance.getPagedTransactions(_limit, 0);
    if (items.length < _limit) {
      _hasMore = false;
    } else {
      _hasMore = true;
    }
    return items;
  }

  Future<void> refresh() async {
    _offset = 0;
    _hasMore = true;
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => DatabaseHelper.instance.getPagedTransactions(_limit, 0),
    );
  }

  Future<void> fetchMore() async {
    if (!_hasMore || state.isLoading) return;

    final currentData = state.value ?? [];
    _offset += _limit;

    final newItems = await DatabaseHelper.instance.getPagedTransactions(
      _limit,
      _offset,
    );

    if (newItems.length < _limit) {
      _hasMore = false;
    }

    if (newItems.isEmpty) {
      _hasMore = false;
    } else {
      state = AsyncData([...currentData, ...newItems]);
    }
  }

  Future<void> deleteTransaction(TransactionModel transaction) async {
    await DatabaseHelper.instance.deleteTransaction(transaction);
    ref.invalidateSelf();
  }

  Future<void> deleteAllTransactions() async {
    await DatabaseHelper.instance.deleteAllTransactions();
    ref.invalidateSelf();
  }
}
