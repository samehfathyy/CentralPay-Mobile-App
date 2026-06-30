import 'package:bloc/bloc.dart';
import 'package:budgeta/core/network/api_result.dart';
import 'package:budgeta/models/transaction.dart' as model;
import 'package:budgeta/normal%20user%20features/add%20transaction/data/transaction_repository.dart';
import 'package:meta/meta.dart';

part 'restore_transactions_state.dart';

class RestoreTransactionsCubit extends Cubit<RestoreTransactionsState> {
  RestoreTransactionsCubit({required this.transaction_repo})
    : super(RestoreTransactionsInitial());
  final TransactionRepository transaction_repo;
  Future<void> restoreTransactions() async {
    emit(RestoreTransactionsLoading());
    // await Future.delayed(Duration(seconds: 4));
    // emit(RestoreTransactionsSuccess());
    final result = await transaction_repo.restoreTransactions();
    result.when(
      success: (response) {
        List<model.Transaction> transactions = [];
        for (var t in response.data.trans) {
          transactions.add(
            model.Transaction(
              id: 0,
              amount: t.amount,
              category: transaction_repo.expenseCategories.firstWhere(
                (element) => element.name == t.category,
              ),
              datetime: t.date,
            ),
          );
        }
        transaction_repo.addMultipleTransactions(transactions);
        emit(RestoreTransactionsSuccess());
      },
      failure: (error) {
        // Handle the error here
        emit(RestoreTransactionsFailure());
      },
    );
  }
}
