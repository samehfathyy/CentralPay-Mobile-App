import 'package:bloc/bloc.dart';
import 'package:budgeta/normal%20user%20features/add%20transaction/data/transaction_repository.dart';
import 'package:budgeta/models/transaction.dart' as model;
import 'package:meta/meta.dart';

part 'monthly_transacrions_state.dart';

class MonthlyTransacrionsCubit extends Cubit<MonthlyTransacrionsState> {
  MonthlyTransacrionsCubit(this._transactionRepository)
    : super(MonthlyTransacrionsInitial());
  final TransactionRepository _transactionRepository;
  late List<model.Transaction> transactions;
  Future<void> loadMonthlyTransactions(DateTime monthYear) async {
    transactions = await _transactionRepository.loadOneMonthTransactions(
      monthYear,
    );
    emit(MonthlyTransacrionsLoaded(transactions: transactions));
  }

  

  void selectTransactionType(String type) {
    if (type == "expense") {
      emit(
        MonthlyTransacrionsLoaded(
          transactions: transactions
              .where((element) => element.category.isExpense)
              .toList(),
        ),
      );
      return;
    }
    if (type == "income") {
      emit(
        MonthlyTransacrionsLoaded(
          transactions: transactions
              .where((element) => !element.category.isExpense)
              .toList(),
        ),
      );
      return;
    }
    //all
    emit(MonthlyTransacrionsLoaded(transactions: transactions));
  }
}
