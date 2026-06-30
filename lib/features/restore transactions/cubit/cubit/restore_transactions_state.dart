part of 'restore_transactions_cubit.dart';

@immutable
sealed class RestoreTransactionsState {}

final class RestoreTransactionsInitial extends RestoreTransactionsState {}
final class RestoreTransactionsLoading extends RestoreTransactionsState {}
final class RestoreTransactionsSuccess extends RestoreTransactionsState {}
final class RestoreTransactionsFailure extends RestoreTransactionsState {}
