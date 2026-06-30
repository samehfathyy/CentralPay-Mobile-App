part of 'add_transaction_cubit.dart';

@immutable
class AddTransactionState {
  final bool isExpense;
  final DateTime dateTime;
  final model.Category? selectedCategory;
  final double amount;
  // final List<model.Category> categories;
  final List<model.Category> expenseCategories;
  final List<model.Category> incomeCategories;

  const AddTransactionState({
    required this.amount,
    required this.isExpense,
    required this.dateTime,
    required this.selectedCategory,
    // required this.categories,
    required this.expenseCategories,
    required this.incomeCategories,
  });
  AddTransactionState copyWith({
    double? amount,
    bool? isExpense,
    DateTime? dateTime,
    model.Category? selectedCategory,
    // List<model.Category>? categories,
    List<model.Category>? expenseCategories,
    List<model.Category>? incomeCategories,
    bool resetCategory = false,
  }) {
    return AddTransactionState(
      amount: amount ?? this.amount,
      isExpense: isExpense ?? this.isExpense,
      dateTime: dateTime ?? this.dateTime,
      selectedCategory:resetCategory ? null    : selectedCategory ?? this.selectedCategory,
      // categories: categories ?? this.categories,
      expenseCategories: expenseCategories ?? this.expenseCategories,
      incomeCategories: incomeCategories ?? this.incomeCategories,
    );
  }
}

// final class AddTransactionIniti extends AddTransactionState {}

// final class AddTransactionLoaded extends AddTransactionState {
//   final List<model.Category> categories;

//   AddTransactionLoaded({required this.categories});
// }
