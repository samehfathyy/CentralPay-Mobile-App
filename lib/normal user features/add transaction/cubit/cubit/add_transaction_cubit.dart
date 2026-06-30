
import 'package:bloc/bloc.dart';
import 'package:budgeta/normal%20user%20features/add%20transaction/data/transaction_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:budgeta/models/category.dart' as model;
import 'package:budgeta/models/transaction.dart' as model;

part 'add_transaction_state.dart';

class AddTransactionCubit extends Cubit<AddTransactionState> {
  AddTransactionCubit(this.transactionRepository)
    : super(
        AddTransactionState(
          amount: 0,
          isExpense: true,
          dateTime: DateTime.now(),
          selectedCategory: null,
          // categories: [],
          expenseCategories: [],
          incomeCategories: [],
        ),
      );
  final TransactionRepository transactionRepository;
  // List<model.Category> categories = [];
  // bool isExpense = true;
  // model.Category? selectedCategory;

  // Future<void> getCategories() async {
  //   final list = await _transactionRepository.getCategories();
  //   emit(state.copyWith(categories: list));
  // }

  List<model.Category> getExpenseCategories() {
    return transactionRepository.expenseCategories;
  }

  List<model.Category> getIncomeCategories() {
    return transactionRepository.incomeCategories;
  }

  void setIsExpense(bool value) {
    emit(state.copyWith(isExpense: value));
  }

  void clearAllFields() {
    emit(
      state.copyWith(
        isExpense: true,
        dateTime: DateTime.now(),
        selectedCategory: null,
        amount: 0.0,
        resetCategory: true,
      ),
    );
  }

  void updateDate(DateTime dateTime) {
    emit(state.copyWith(dateTime: dateTime));
  }

  void updateAmount(double amount) {
    emit(state.copyWith(amount: amount));
  }

  void selectCategory(model.Category category) {
    emit(state.copyWith(selectedCategory: category));
  }

  void resetCategorySelection() {
    emit(state.copyWith(selectedCategory: null, resetCategory: true));
  }

  // Future<bool> saveTransaction(double amount) async {
  //   if (state.selectedCategory == null ||
  //       amount <= 0 ||
  //       selectedCategory == null) {
  //     return false;
  //   }
  //   // await _transactionRepository.addTransaction(
  //   //   category: state.categoryId!,
  //   //   amount: amount,
  //   //   datetime: state.dateTime,
  //   //   isExpense: selectedCategory!.isExpense,
  //   // );
  //   return true;
  // }

  Future<bool> saveTransaction() async {
    if (state.selectedCategory == null || state.amount <= 0) {
      return false;
    }
    final t = model.Transaction(
      id: 0,
      amount: state.amount,
      category: state.selectedCategory!,
      datetime: state.dateTime,
    );
    // print("${state.selectedCategory} ${state.amount} ${state.dateTime}");
    try {
      final success = await transactionRepository.addTransaction(
        transaction: t,
      );
      // print("success ${success}");
      clearAllFields();
      return success;
    } catch (e) {
      // print(e.toString());
      return false;
    }
  }

  void setCategoryByName(String categoryName) {
    model.Category? c = transactionRepository.expenseCategories
        .where((element) => element.name == categoryName)
        .first;
    c ??= transactionRepository.expenseCategories.last;
    selectCategory(c);
  }

  Future<void> enterTransactionDetails(
    String category,
    double amount,
    int date,
  ) async {
    model.Category? c =
        transactionRepository.expenseCategories.where(
              (element) => element.name == category,
            )
            as model.Category?;
    c ??= transactionRepository.expenseCategories.last;
    emit(
      state.copyWith(
        amount: amount,
        dateTime: DateTime.fromMillisecondsSinceEpoch(date),
        selectedCategory: c,
        isExpense: true,
      ),
    );
  }

  Future<void> backup()async{
    await transactionRepository.backupTransactions();
  }

}
