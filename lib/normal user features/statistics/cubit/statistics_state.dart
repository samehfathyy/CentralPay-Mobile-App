part of 'statistics_cubit.dart';

@immutable
sealed class StatisticsState {}

final class StatisticsInitial extends StatisticsState {}

final class StatisticsPieChartDataLoading extends StatisticsState {}
final class StatisticsPieChartDataEmpty extends StatisticsState {}

final class StatisticsPieChartDataLoaded extends StatisticsState {
  final Map<String, double> categoryTotals;
  final Map<String, Color> categoriesColors;
  final double totalAmount;
  final List<FlSpot> dailySpots;

  StatisticsPieChartDataLoaded({
    required this.categoryTotals,
    required this.categoriesColors,
    required this.totalAmount,
    required this.dailySpots,
  });
}
