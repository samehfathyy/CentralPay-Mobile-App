part of 'monthly_transacrions_cubit.dart';

@immutable
sealed class MonthlyTransacrionsState {}

final class MonthlyTransacrionsInitial extends MonthlyTransacrionsState {}

final class MonthlyTransacrionsLoading extends MonthlyTransacrionsState {}

final class MonthlyTransacrionsLoaded extends MonthlyTransacrionsState {
  final List<model.Transaction> transactions;

  MonthlyTransacrionsLoaded({required this.transactions});
}

final class MonthlyTransacrionsError extends MonthlyTransacrionsState {}
