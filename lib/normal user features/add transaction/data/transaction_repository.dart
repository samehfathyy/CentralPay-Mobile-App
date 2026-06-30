import 'package:budgeta/core/database/dbHelper.dart';
import 'package:budgeta/core/helpers/DateHelpers.dart';
import 'package:budgeta/core/network/api_result.dart';
import 'package:budgeta/core/network/api_service.dart';
import 'package:budgeta/features/backup%20transactions/backup__response.dart';
import 'package:budgeta/features/backup%20transactions/backup_request_body.dart';
import 'package:budgeta/features/restore%20transactions/restore_response.dart';
import 'package:budgeta/models/category.dart' as model;
import 'package:budgeta/models/category_factory.dart';
import 'package:budgeta/models/transaction.dart' as model;

class TransactionRepository {
  final DBHelper dbHelper;
  final ApiService apiService;
  TransactionRepository({required this.apiService, required this.dbHelper});
  List<model.Transaction> recentTransactions = [];
  List<model.Category> expenseCategories = [];
  List<model.Category> incomeCategories = [];

  Future<bool> addTransaction({required model.Transaction transaction}) async {
    final t = await dbHelper.insertTransaction(transaction: transaction);
    if (recentTransactions.isEmpty) {
      recentTransactions.add(t);
      return true;
    }
    final index = recentTransactions.indexWhere(
      (element) => element.datetime.isBefore(t.datetime),
    );

    if (index == -1) {
      recentTransactions.add(t);
      return true;
    }
    recentTransactions.insert(index, t);
    // print("null id");
    return true;
  }

  Future<void> addMultipleTransactions(
    List<model.Transaction> transactions,
  ) async {
    await dbHelper.insertTransactions(transactions);
  }

  Future<bool> deleteTransaction(int id) async {
    final success = await dbHelper.deleteTransaction(id);
    if (success) {
      recentTransactions.removeWhere((element) => element.id == id);
    }
    return success;
  }

  Future<void> loadExpenseAndIncomeCategories() async {
    List<model.Category> list = await dbHelper.getCategories();
    CategoryFactory.preload(list);
    for (var element in list) {
      element.isExpense
          ? expenseCategories.add(element)
          : incomeCategories.add(element);
    }
  }

  Future<List<model.Transaction>> loadRecentTransactions() async {
    DateTime start = DateTime.now()
        .subtract(Duration(days: 2))
        .removeTimePart();
    DateTime end = DateTime.now().add(Duration(days: 1)).removeTimePart();
    final transactions = await dbHelper.getTransactionsByDateRange(start, end);
    // int days = 2;//today and yesterday
    print("Initial recent transactions loaded: ${transactions.length}");

    // while (days > 0) {
    //   start = start.subtract(Duration(days: 1));
    //   end = end.subtract(Duration(days: 1));
    //   final olderTransactions = await dbHelper.getTransactionsByDateRange(
    //     start,
    //     end,
    //   );
    //   transactions.addAll(olderTransactions);
    //   days--;
    // }
    // if (transactions.isEmpty) {
    //   start = start.subtract(Duration(days: 14));
    //   end =  DateTime.now().removeTimePart();
    //   final olderTransactions = await dbHelper.getTransactionsByDateRange(
    //     start,
    //     end,
    //   );
    //   transactions.addAll(olderTransactions.take(10));
    // }

    recentTransactions = transactions;
    return recentTransactions;
  }

  Future<List<model.Transaction>> loadOneMonthExpenses(
    DateTime monthYear,
  ) async {
    DateTime start = DateTime(
      monthYear.year,
      monthYear.month,
      -1,
    ).removeTimePart();
    DateTime end = DateTime(
      monthYear.year,
      monthYear.month + 1,
      1,
    ).removeTimePart();
    final transactions =
        await dbHelper.getExpensesByDateRange(start, end) ?? [];
    return transactions;
  }

  Future<List<model.Transaction>> LoadLastWeekTransactions() async {
    DateTime start = DateTime.now()
        .subtract(Duration(days: 7))
        .removeTimePart();
    DateTime end = DateTime.now().add(Duration(days: 1)).removeTimePart();
    final transactions =
        await dbHelper.getTransactionsByDateRange(start, end) ?? [];
    //filter expenses only
    transactions.removeWhere((element) => !element.category.isExpense);
    return transactions;
  }

  Future<List<model.Transaction>> loadOneMonthTransactions(
    DateTime monthYear,
  ) async {
    DateTime start = DateTime(
      monthYear.year,
      monthYear.month,
      -1,
    ).removeTimePart();
    DateTime end = DateTime(
      monthYear.year,
      monthYear.month + 1,
      1,
    ).removeTimePart();
    final transactions =
        await dbHelper.getTransactionsByDateRange(start, end) ?? [];
    return transactions;
  }

  Future<List<model.Transaction>> getAllTransactions() async {
    final transactions = await dbHelper.getTransactions() ?? [];
    return transactions;
  }

  Future<ApiResult<BackupResponse>> backupTransactions() async {
    try {
      List<model.Transaction> transactions = await getAllTransactions();
      List<BackupTransaction> backupTransactions = transactions.map((e) {
        print(
          "backup transaction: ${e.category.name}, ${e.amount}, ${e.category.isExpense}",
        );
        return BackupTransaction(
          category: e.category.name,
          amount: e.amount,
          date: e.datetime.millisecondsSinceEpoch.toString(),
          expense: e.category.isExpense,
        );
      }).toList();
      final request = BackupRequestBody(transactions: backupTransactions);
      // print(request.transactions)
      for (var element in request.transactions) {
        print(
          "backup request transaction: ${element.category}, ${element.amount}, ${element.expense}, ${element.date} ",
        );
      }
      final response = await apiService.backupTransactions(request);
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(e.toString());
    }
  }

  Future<ApiResult<RestoreResponse>> restoreTransactions() async {
    print("restore transactions called");
    try {
      final response = await apiService.getRecentTransactions();

      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(e.toString());
    }
  }

  Future<void> clearTransactions() async {
    await dbHelper.clearTransactions();
  }
  //not updated fun \  /
  //                 \/

  Future<void> addInitialCategories() async {
    List<model.Category> categories = [
      model.Category(id: 0, name: "Food & Groceries", isExpense: true),
      model.Category(id: 0, name: "Dining Out", isExpense: true),
      model.Category(id: 0, name: "Transportation", isExpense: true),
      model.Category(id: 0, name: "Housing / Rent", isExpense: true),
      model.Category(id: 0, name: "Utilities", isExpense: true),
      model.Category(id: 0, name: "Health & Medical", isExpense: true),
      model.Category(id: 0, name: "Entertainment", isExpense: true),
      model.Category(id: 0, name: "Shopping", isExpense: true),
      model.Category(id: 0, name: "Education", isExpense: true),
      model.Category(id: 0, name: "Personal Care", isExpense: true),
      model.Category(id: 0, name: "Other", isExpense: true),
      //income
      model.Category(id: 0, name: "Salary", isExpense: false),
      model.Category(id: 0, name: "Freelance", isExpense: false),
      model.Category(id: 0, name: "Business Income", isExpense: false),
      model.Category(id: 0, name: "Investments", isExpense: false),
      model.Category(id: 0, name: "Rental Income", isExpense: false),
      model.Category(id: 0, name: "Bonuses", isExpense: false),
      model.Category(id: 0, name: "Gifts Received", isExpense: false),
      model.Category(id: 0, name: "Refunds", isExpense: false),
      model.Category(id: 0, name: "Interest", isExpense: false),
      model.Category(id: 0, name: "Other Income", isExpense: false),
    ];
    await dbHelper.insertCategories(categories);
  }

  // Future<List<model.Category>> getCategories() async {
  //   final list = await dbHelper.getCategories();
  //   print("repo ${list.length}");
  //   return list;
  // }

  // Future<List<model.Category>> getExpenseCategories() async {
  //   List<Category> list = await dbHelper.getCategories();
  //   list.removeWhere((element) => !element.isExpense);
  //   return list;
  // }

  // Future<List<model.Category>> getIncomeCategories() async {
  //   List<model.Category> list = await dbHelper.getCategories();
  //   list.removeWhere((element) => element.isExpense);
  //   return list;
  // }
}
