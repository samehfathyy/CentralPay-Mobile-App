
import 'package:animate_do/animate_do.dart';
import 'package:budgeta/core/helpers/DateHelpers.dart';
import 'package:budgeta/core/theming/App_Colors.dart';
import 'package:budgeta/normal%20user%20features/all%20transactions/monthly_transactions_screen.dart';
import 'package:budgeta/normal%20user%20features/statistics/cubit/statistics_cubit.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StatisticsScreen extends StatefulWidget {
  final Key fadeInKey;
  final Key fadeInKey2;
  const StatisticsScreen({
    required this.fadeInKey,
    required this.fadeInKey2,
    super.key,
  });

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    context.read<StatisticsCubit>().getAnalytics(DateTime.now());
    // });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double radius = (screenWidth * 0.22);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Monthly Analytics",
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500),
        ),
        actions: [
          IconButton(
            onPressed: () {
              context.read<StatisticsCubit>().refreshPage();
            },
            icon: Icon(Icons.refresh, color: AppColors.blue),
          ),
        ],
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.white,
      ),
      body: SafeArea(
        child: Stack(
          alignment: AlignmentGeometry.bottomCenter,
          children: [
            BlocBuilder<StatisticsCubit, StatisticsState>(
              builder: (context, state) {
                final selectedMonth = context
                    .read<StatisticsCubit>()
                    .selectedMonth;
                if (state is StatisticsPieChartDataEmpty) {
                  return Center(child: Text("No expenses this month"));
                }
                if (state is StatisticsPieChartDataLoading) {
                  return Center(child: CircularProgressIndicator());
                }
                if (state is StatisticsPieChartDataLoaded) {
                  return SizedBox.expand(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          // SizedBox(height: 50.h),
                          FadeInUp(
                            key: widget.fadeInKey,
                            from: 20.h,
                            child: Container(
                              // height: screenWidth + 50,
                              margin: EdgeInsets.all(15.w),
                              padding: EdgeInsets.all(15.w),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: Offset(
                                      0,
                                      3,
                                    ), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Spending Overview",
                                        style: TextStyle(fontSize: 18.sp),
                                      ),

                                      // InkWell(
                                      //   onTap: () async {
                                      //     final DateTime?
                                      //     selectedDate = await showMonthPicker(
                                      //       context: context,
                                      //       firstDate: DateTime(2000),
                                      //       lastDate: DateTime.now(),
                                      //       initialDate: selectedMonth,
                                      //       monthPickerDialogSettings:
                                      //           MonthPickerDialogSettings(
                                      //             headerSettings: PickerHeaderSettings(
                                      //               headerBackgroundColor:
                                      //                   Colors.blue,
                                      //               headerCurrentPageTextStyle:
                                      //                   TextStyle(
                                      //                     color: Colors.white,
                                      //                     fontSize: 18.sp,
                                      //                   ),
                                      //               headerSelectedIntervalTextStyle:
                                      //                   TextStyle(
                                      //                     fontSize: 0,
                                      //                     color: Colors.white70,
                                      //                   ),
                                      //             ),
                                      //             dialogSettings:
                                      //                 PickerDialogSettings(
                                      //                   dialogBackgroundColor:
                                      //                       Colors.white,
                                      //                 ),
                                      //             dateButtonsSettings:
                                      //                 PickerDateButtonsSettings(
                                      //                   selectedMonthBackgroundColor:
                                      //                       Colors.blue,
                                      //                   unselectedMonthsTextColor:
                                      //                       Colors.black,
                                      //                   selectedMonthTextColor:
                                      //                       Colors.white,
                                      //                 ),
                                      //             actionBarSettings:
                                      //                 PickerActionBarSettings(
                                      //                   confirmWidget: Text(
                                      //                     "OK",
                                      //                     style: TextStyle(
                                      //                       color: Colors.blue,
                                      //                     ),
                                      //                   ),
                                      //                   cancelWidget: Text(
                                      //                     "CANCEL",
                                      //                     style: TextStyle(
                                      //                       color: Colors.grey,
                                      //                     ),
                                      //                   ),
                                      //                 ),
                                      //           ),
                                      //     );
                                      //     if (selectedDate != null) {
                                      //       context
                                      //           .read<StatisticsCubit>()
                                      //           .getAnalytics(
                                      //             DateTime(
                                      //               selectedDate.year,
                                      //               selectedDate.month,
                                      //             ),
                                      //           );
                                      //     }
                                      //   },
                                      //   child: Container(
                                      //     padding: EdgeInsets.symmetric(
                                      //       horizontal: 10,
                                      //       vertical: 3,
                                      //     ),
                                      //     decoration: BoxDecoration(
                                      //       color: AppColors.lightgrey,
                                      //       borderRadius: BorderRadius.circular(
                                      //         16.sp,
                                      //       ),
                                      //     ),
                                      //     child: Row(
                                      //       children: [
                                      //         Text(
                                      //           "${selectedMonth.getMonthName()} ${selectedMonth.year}",
                                      //         ),
                                      //         Icon(
                                      //           Icons.arrow_drop_down_outlined,
                                      //         ),
                                      //       ],
                                      //     ),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                  SizedBox(height: 15),

                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      CategoriesPieChart(
                                        categoriesColors:
                                            state.categoriesColors,
                                        categoryTotals: state.categoryTotals,
                                        totalAmount: state.totalAmount,
                                        radius: radius,
                                      ),

                                      // SizedBox(width: 15.h),
                                      CategoriesColumn(
                                        categoriesColors:
                                            state.categoriesColors,
                                        categoryTotals: state.categoryTotals,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // SizedBox(height: 120.h),
                          FadeInUp(
                            key: widget.fadeInKey2,
                            from: 20.h,
                            delay: Duration(milliseconds: 300),
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 15.w),
                              padding: EdgeInsets.all(15.w),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: Offset(
                                      0,
                                      3,
                                    ), // changes position of shadow
                                  ),
                                ],
                              ),
                              // height: 300,
                              width: screenWidth - 20.w,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Total Daily Expenses",
                                    style: TextStyle(fontSize: 18.sp),
                                  ),
                                  SizedBox(height: 15),
                                  SizedBox(
                                    height: 300,
                                    child: LineChart(
                                      LineChartData(
                                        minY: 0.0,
                                        maxX: 31,
                                        minX: 1,
                                        titlesData: FlTitlesData(
                                          topTitles: AxisTitles(
                                            sideTitles: SideTitles(
                                              showTitles: false,
                                            ),
                                          ),
                                          rightTitles: AxisTitles(
                                            sideTitles: SideTitles(
                                              showTitles: false,
                                            ),
                                          ),
                                          leftTitles: AxisTitles(
                                            sideTitles: SideTitles(
                                              showTitles: true,
                                              reservedSize: 40,
                                              maxIncluded: false,
                                              minIncluded: true,
                                            ),
                                          ),
                                          bottomTitles: AxisTitles(
                                            sideTitles: SideTitles(
                                              showTitles: true,
                                              reservedSize: 40,
                                              interval: 3,
                                              maxIncluded: false,
                                              minIncluded: false,
                                            ),
                                          ),
                                        ),
                                        borderData: FlBorderData(
                                          border: Border(
                                            bottom: BorderSide(
                                              color: AppColors.grey,
                                              width: 1,
                                            ),
                                            left: BorderSide(
                                              color: Colors.transparent,
                                              width: 1,
                                            ),
                                            right: BorderSide(
                                              color: Colors.transparent,
                                            ),
                                            top: BorderSide(
                                              color: Colors.transparent,
                                            ),
                                          ),
                                        ),
                                        gridData: FlGridData(show: false),
                                        // lineTouchData: LineTouchData(enabled: false),
                                        lineBarsData: [
                                          LineChartBarData(
                                            spots: state.dailySpots,
                                            preventCurveOverShooting: true,
                                            barWidth: 3,
                                            color: Colors.blue,
                                            dotData: FlDotData(show: false),
                                            belowBarData: BarAreaData(
                                              show: false,
                                            ),
                                            isCurved: true,
                                            curveSmoothness: 0.2,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 100.h),
                          
                        ],
                      ),
                    ),
                  );
                }
                return Center(child: Text("An error occured"));
              },
            ),

            MonthSelectSlide(
              oncallback: (dt) {
                context.read<StatisticsCubit>().getAnalytics(
                  DateTime(dt.year, dt.month),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class MonthPicker extends StatefulWidget {
  const MonthPicker({super.key});

  @override
  State<MonthPicker> createState() => _MonthPickerState();
}

class _MonthPickerState extends State<MonthPicker> {
  late final ScrollController _scrollController;
  int year = DateTime.now().year;
  // int month = DateTime.now().month;
  int month = DateTime.now().month;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final double itemWidth = 55.w; // padding + margin + text
      final double offset = (month - 1) * itemWidth;

      _scrollController.jumpTo(
        offset.clamp(0.0, _scrollController.position.maxScrollExtent),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15.w),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    year--;
                  });
                  context.read<StatisticsCubit>().getAnalytics(
                    DateTime(year, month),
                  );
                },
                icon: Icon(Icons.arrow_back_ios),
              ),
              Text(year.toString(), style: TextStyle(fontSize: 18.sp)),
              IconButton(
                onPressed: () {
                  setState(() {
                    year++;
                  });
                  context.read<StatisticsCubit>().getAnalytics(
                    DateTime(year, month),
                  );
                },
                icon: Icon(Icons.arrow_forward_ios),
              ),
            ],
          ),
          // Text("Month"),
          Padding(
            padding: EdgeInsets.all(8.w),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              controller: _scrollController,
              child: Row(
                children: List.generate(12, (index) {
                  final selected = index + 1 == month;
                  return InkWell(
                    onTap: () {
                      setState(() {
                        month = index + 1;
                      });
                      print(year);
                      print(month);
                      context.read<StatisticsCubit>().getAnalytics(
                        DateTime(year, month),
                      );
                    },
                    child: Container(
                      // padding: EdgeInsets.symmetric(
                      //   horizontal: 20.w,
                      //   vertical: 20.h,
                      // ),
                      width: 50.w,
                      height: 65.w,
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(right: 5.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.r),
                        color: selected ? AppColors.blue : AppColors.lightgrey,
                      ),
                      child: Text(
                        // (index + 1).toString(),
                        monthName(index + 1).substring(0, 3),
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: selected ? AppColors.white : AppColors.black,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryColoredHeader extends StatelessWidget {
  const CategoryColoredHeader({
    super.key,
    required this.categoryColor,
    required this.name,
  });

  final Color? categoryColor;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.circle, color: categoryColor, size: 10.sp),
        Text(
          " $name",
          style: TextStyle(
            fontSize: 14.sp,
            color: categoryColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        // SizedBox(width: 20.w),
      ],
    );
  }
}

class CategoriesColumn extends StatelessWidget {
  const CategoriesColumn({
    super.key,
    required this.categoriesColors,
    required this.categoryTotals,
  });
  final Map categoriesColors;
  final Map categoryTotals;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.start,
      direction: Axis.vertical,
      crossAxisAlignment: WrapCrossAlignment.start,
      runAlignment: WrapAlignment.start,
      // verticalDirection: VerticalDirection.up,
      children: List.generate(categoryTotals.length, (index) {
        final name = categoriesColors.keys.toList()[index];
        return CategoryColoredHeader(
          name: name,
          categoryColor: categoriesColors[name],
        );
      }),
    );
  }
}

class CategoriesPieChart extends StatelessWidget {
  const CategoriesPieChart({
    super.key,
    required this.categoriesColors,
    required this.categoryTotals,
    required this.totalAmount,
    required this.radius,
  });
  final Map categoriesColors;
  final Map categoryTotals;
  final double totalAmount;
  final double radius;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: (radius * 2) + 5,
      width: (radius * 2) + 5,
      child: PieChart(
        PieChartData(
          centerSpaceRadius: 0,
          titleSunbeamLayout: false,
          sections: List.generate(categoriesColors.length, (index) {
            final String categoryName = categoriesColors.keys.toList()[index];
            final double categoryTotal = categoryTotals[categoryName] ?? 0.0;
            final Color categoryColor = categoriesColors[categoryName]!;
            final double percentage = (categoryTotal / totalAmount) * 100;
            return PieChartSectionData(
              showTitle: percentage > 10,
              color: categoryColor,

              value: categoryTotal,
              title: '${percentage.toInt()}%',
              radius: radius,
              titleStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            );
          }),
        ),
      ),
    );
  }
}
