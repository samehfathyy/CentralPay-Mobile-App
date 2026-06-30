
import 'package:bloc/bloc.dart';
import 'package:budgeta/core/helpers/DateHelpers.dart';
import 'package:budgeta/normal%20user%20features/add%20transaction/data/transaction_repository.dart';
import 'package:budgeta/models/transaction.dart' as model;
import 'package:meta/meta.dart';

part 'transactions_state.dart';

class TransactionsCubit extends Cubit<TransactionsState> {
  TransactionsCubit(this._transactionRepository)
    : super(
        TransactionsState(
          recentTransactions: [],
          totalExpenseAndIncome: TotalExpenseAndIncome(
            totalExpense: 0.0,
            totalIncome: 0.0,
          ),
        ),
      );
  final TransactionRepository _transactionRepository;

  // List<model.Transaction> getRecentTransactions() {
  //   return _transactionRepository.recentTransactions;
  // }
  Future<void> loadRecentTransactions() async {
    await _transactionRepository.loadExpenseAndIncomeCategories();
    await _transactionRepository.loadRecentTransactions();
    emit(
      state.copyWith(
        recentTransactions: _transactionRepository.recentTransactions,
        totalExpenseAndIncome: updateTotals(),
      ),
    );
  }

  void refreshRecentTransactions() {
    emit(
      state.copyWith(
        recentTransactions: _transactionRepository.recentTransactions,
        totalExpenseAndIncome: updateTotals(),
      ),
    );
  }

  TotalExpenseAndIncome updateTotals() {
    final todayTransactions = _transactionRepository.recentTransactions
        .where(
          (t) => t.datetime.removeTimePart() == DateTime.now().removeTimePart(),
        )
        .toList();
    double totalExpense = 0.0;
    double totalIncome = 0.0;

    for (model.Transaction t in todayTransactions) {
      if (t.category.isExpense) {
        totalExpense += t.amount;
      } else {
        totalIncome += t.amount;
      }
    }

    return TotalExpenseAndIncome(
      totalExpense: totalExpense,
      totalIncome: totalIncome,
    );
  }

  Future<void> deleteTransaction(int id) async {
    final success = await _transactionRepository.deleteTransaction(id);
    if (success) {
      emit(
        state.copyWith(
          recentTransactions: _transactionRepository.recentTransactions,
          totalExpenseAndIncome: updateTotals(),
        ),
      );
    }
  }
  // Future<void> getRecentTransactions() async {
  //   DateTime start = DateTime.now().removeTimePart();
  //   DateTime end = DateTime.now().add(Duration(days: 1)).removeTimePart();
  //   List<model.Transaction> transactions = await _transactionRepository
  //       .getRecentTransactions(start, end);
  //   int days = 4;
  //   while (transactions.length < 10 && days > 0) {
  //     start = start.subtract(Duration(days: 1));
  //     // end = end.subtract(Duration(days: 1));
  //     final olderlist = await _transactionRepository.getRecentTransactions(
  //     );
  //     transactions.addAll(olderlist);
  //     days--;
  //   }
  //   emit(
  //     state.copyWith(
  //       recentTransactions: transactions,
  //     ),
  //   );
  // }

  // Future<bool> addTransaction(model.Transaction t) async {
  //   final id = await _transactionRepository.addTransaction(transaction: t);
  //   if (id == 0) {
  //     return false;
  //   }
  //   t.id = id;
  //   state.recentTransactions.add(t);
  //   emit(state.copyWith(recentTransactions: state.recentTransactions));
  //   if (t.datetime.removeTimePart() == DateTime.now().removeTimePart()) {
  //     emit(
  //       state.copyWith(
  //         recentTransactions: state.recentTransactions,
  //         totalExpenseAndIncome: TotalExpenseAndIncome(
  //           totalExpense:
  //               state.totalExpenseAndIncome.totalExpense +
  //               (t.isExpense ? t.amount : 0),
  //           totalIncome:
  //               state.totalExpenseAndIncome.totalIncome +
  //               (!t.isExpense ? t.amount : 0),
  //         ),
  //       ),
  //     );
  //   }
  //   return true;
  // }
}
