part of 'backup_transactions_cubit.dart';

@immutable
sealed class BackupTransactionsState {}

final class BackupTransactionsInitial extends BackupTransactionsState {}
final class BackupTransactionsLoading extends BackupTransactionsState {}
final class BackupTransactionsSuccess extends BackupTransactionsState {}
final class BackupTransactionsFailure extends BackupTransactionsState {}
