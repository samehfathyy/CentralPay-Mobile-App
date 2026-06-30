part of 'budget_limit_cubit.dart';

@immutable
sealed class BudgetLimitState {}

final class BudgetLimitInitial extends BudgetLimitState {}

final class BudgetLimitLoading extends BudgetLimitState {}

final class BudgetLimitSuccess extends BudgetLimitState {
  List<DailyTotal> totals;
  BudgetLimitSuccess(this.totals);
}

final class BudgetLimitError extends BudgetLimitState {}
