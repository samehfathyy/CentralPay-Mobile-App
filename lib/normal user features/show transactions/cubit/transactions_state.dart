part of 'transactions_cubit.dart';

@immutable
class TransactionsState {
  final List<model.Transaction> recentTransactions;
    // final TransactionRepository _transactionRepository;
  // List<model.Transaction> getRecentTransactions() {
  //   return _transactionRepository.recentTransactions;
  // }
  final TotalExpenseAndIncome totalExpenseAndIncome; 
  const TransactionsState({
    required this.recentTransactions,
    required this.totalExpenseAndIncome,
  });
  TransactionsState copyWith({
    List<model.Transaction>? recentTransactions,
    TotalExpenseAndIncome? totalExpenseAndIncome,
  }) {
    return TransactionsState(
      recentTransactions: recentTransactions ?? this.recentTransactions,
      totalExpenseAndIncome:
          totalExpenseAndIncome ?? this.totalExpenseAndIncome,
    );
  }
}

class TotalExpenseAndIncome {
  final double totalExpense;
  final double totalIncome;

  TotalExpenseAndIncome({
    required this.totalExpense,
    required this.totalIncome,
  });
}

// final class TransactionsInitial extends TransactionsState {}
