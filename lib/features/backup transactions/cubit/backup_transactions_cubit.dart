import 'package:bloc/bloc.dart';
import 'package:budgeta/core/network/api_result.dart';
import 'package:budgeta/normal%20user%20features/add%20transaction/data/transaction_repository.dart';
import 'package:meta/meta.dart';

part 'backup_transactions_state.dart';

class BackupTransactionsCubit extends Cubit<BackupTransactionsState> {
  BackupTransactionsCubit(this.transaction_repo) : super(BackupTransactionsInitial());
  final TransactionRepository transaction_repo;
  Future<void> backupTransactions() async {
    emit(BackupTransactionsLoading());
    // await Future.delayed(Duration(seconds: 4));
    // emit(BackupTransactionsSuccess());
    final result = await transaction_repo.backupTransactions();
    result.when(
      success: (response) {
        //store new last backup date
        emit(BackupTransactionsSuccess());
      },
      failure: (error) {
        // Handle the error here
        emit(BackupTransactionsFailure());
      },
    );
  }
}
