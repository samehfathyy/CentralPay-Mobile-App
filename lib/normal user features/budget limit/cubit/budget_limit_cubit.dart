import 'package:bloc/bloc.dart';
import 'package:budgeta/core/constansts/shared_pref_cons.dart';
import 'package:budgeta/main.dart';
import 'package:budgeta/models/transaction.dart' as model;
import 'package:budgeta/normal%20user%20features/add%20transaction/data/transaction_repository.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

part 'budget_limit_state.dart';

class BudgetLimitCubit extends Cubit<BudgetLimitState> {
  BudgetLimitCubit(TransactionRepository transactionRepository)
    : _transactionRepository = transactionRepository,
      super(BudgetLimitInitial());
  final TransactionRepository _transactionRepository;
  late List<model.Transaction> transactions;
  double limit = 100;
  double highestTotal = 100;
  List<DailyTotal> ls = [];

  Future<double> loadBudgetLimitValue() async {
    limit =
        sharedPrefs.getDouble(SharedPrefCons.dailyBudgetLimit) ?? 100.0;
    return limit;
  }

  Future<void> loadTransactions() async {
    emit(BudgetLimitLoading());
    loadBudgetLimitValue();
    try {
      transactions = await _transactionRepository.LoadLastWeekTransactions();
      ls = getDailyTotals();
      // for (var element in ls) {
      //   print("${element.day}:${element.total}");
      // }
      emit(BudgetLimitSuccess(ls));
    } catch (e) {
      emit(BudgetLimitError());
    }
  }

  List<DailyTotal> getDailyTotals() {
    final Map<String, double> dayTotalsMap = {};

    DateTime firstDayOfWeek = DateTime.now().subtract(Duration(days: 6));
    for (int i = 0; i < 7; i++) {
      dayTotalsMap[DateFormat(
            'E',
          ).format(firstDayOfWeek.add(Duration(days: i)))] =
          0.0;
    }
    for (var t in transactions) {
      String dayName = DateFormat('E').format(t.datetime);
      dayTotalsMap[dayName] = (dayTotalsMap[dayName] ?? 0.0) + t.amount;
    }

    List<DailyTotal> dailyTotalsList = dayTotalsMap.entries.map((entry) {
      return DailyTotal(entry.key, entry.value);
    }).toList();
    highestTotal = dailyTotalsList.fold<double>(
      0.0,
      (previousValue, element) =>
          element.total > previousValue ? element.total : previousValue,
    );
    // for (var element in dailyTotalsList) {

    // }

    return dailyTotalsList;
  }

  void updateLimit(double newLimit) async {
    limit = newLimit;
    await sharedPrefs.setDouble(SharedPrefCons.dailyBudgetLimit, newLimit);
    emit(BudgetLimitSuccess(ls));
  }
}

class DailyTotal {
  String day;
  double total;
  DailyTotal(this.day, this.total);
}
