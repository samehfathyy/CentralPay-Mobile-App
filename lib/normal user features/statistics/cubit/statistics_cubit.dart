import 'package:bloc/bloc.dart';
import 'package:budgeta/normal%20user%20features/add%20transaction/data/transaction_repository.dart';
import 'package:budgeta/models/transaction.dart' as model;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

part 'statistics_state.dart';

class StatisticsCubit extends Cubit<StatisticsState> {
  StatisticsCubit(this._transactionRepository) : super(StatisticsInitial());
  final TransactionRepository _transactionRepository;
  late List<model.Transaction> transactions;
  late DateTime selectedMonth;

  Future<void> getMonthTransactions(DateTime monthYear) async {
    transactions = await _transactionRepository.loadOneMonthExpenses(
      monthYear,
    );
  }

  Future<void> refreshPage() async {
    await getAnalytics(selectedMonth);
  }

  Future<void> getAnalytics(DateTime monthYear) async {
    emit(StatisticsPieChartDataLoading());
    selectedMonth = monthYear;
    await getMonthTransactions(monthYear);
    if (transactions.isEmpty) {
      emit(StatisticsPieChartDataEmpty());
      return;
    }
    // final list = await _transactionRepository.loadOneMonthExpenses(month_year);
    double totalAmount = 0.0;
    Map<String, double> categoryTotals = {};
    Map<int, double> dailyTotals = {};
    final int daysInMonth = DateUtils.getDaysInMonth(
      monthYear.year,
      monthYear.month,
    );
    for (int day = 1; day <= daysInMonth; day++) {
      dailyTotals[day] = 0.0;
    }
    for (model.Transaction t in transactions) {
      totalAmount += t.amount;

      final String categoryName = t.category.name;
      dailyTotals[t.datetime.day] =
          (dailyTotals[t.datetime.day] ?? 0.0) + t.amount;
      categoryTotals[categoryName] =
          (categoryTotals[categoryName] ?? 0.0) + t.amount;
    }

    Map<String, Color> categoriesColors = assignColorsForCategories(
      categoryTotals,
    );

    List<FlSpot> dailySpots = dailyTotals.entries
        .map((entry) => FlSpot(entry.key.toDouble(), entry.value))
        .toList();

    for (FlSpot s in dailySpots) {
      print("${s.x},${s.y}");
    }

    emit(
      StatisticsPieChartDataLoaded(
        categoryTotals: categoryTotals,
        categoriesColors: categoriesColors,
        totalAmount: totalAmount,
        dailySpots: dailySpots,
      ),
    );
  }

  Map<String, Color> assignColorsForCategories(Map categories) {
    List<Color> colors = [
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.yellow,
      Colors.deepPurple,
      Colors.black,
      Colors.orange,
      Colors.brown,
    ];
    Map<String, Color> categoriesColors = {};
    int index = 0;
    categories.forEach((key, value) {
      categoriesColors[key] = colors[index];
      index = (index + 1) % colors.length;
    });

    return categoriesColors;
  }
}
