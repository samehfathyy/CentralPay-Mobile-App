import 'package:budgeta/core/theming/app_fonts.dart';
import 'package:budgeta/normal%20user%20features/budget%20limit/cubit/budget_limit_cubit.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<BudgetLimitCubit>().loadTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Daily Budget", style: AppFonts.black20),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: BlocBuilder<BudgetLimitCubit, BudgetLimitState>(
          builder: (context, state) {
            if (state is BudgetLimitLoading) {
              return Center(child: CircularProgressIndicator());
            }
            if (state is BudgetLimitSuccess) {
              final budgetLimit = context.read<BudgetLimitCubit>().limit;
              final highestTotal = context.read<BudgetLimitCubit>().highestTotal;

              return SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 10.h),
                    InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            final TextEditingController controller =
                                TextEditingController(
                                  text: budgetLimit.toString(),
                                );
                            return AlertDialog(
                              title: Text("Change Budget Limit"),
                              content: TextField(
                                controller: controller,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: "Enter new limit",
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    final newLimit = double.tryParse(
                                      controller.text,
                                    );
                                    if (newLimit != null && newLimit > 0) {
                                      context
                                          .read<BudgetLimitCubit>()
                                          .updateLimit(newLimit);
                                      Navigator.of(context).pop();
                                    }
                                  },
                                  child: Text("Save"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Daily Budget Limit", style: AppFonts.black20),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 8.h,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.r),
                                color: Colors.white,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Text("change    ", style: AppFonts.blue14),
                                  Text(
                                    context
                                        .read<BudgetLimitCubit>()
                                        .limit
                                        .toString(),
                                    style: AppFonts.black20.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  // Icon(Icons.change, size: 30),
                                  SizedBox(width: 5.w),
                                  Icon(
                                    Icons.edit,
                                    color: Colors.blue,
                                    size: 20.sp,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),

                    //
                    // 1. Read your limit once up top to optimize performance inside the loop
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 30.h,
                      ),
                      decoration: BoxDecoration(
                        // border: Border.all(color: Colors.blue, width: 3),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18.r),
                      ),
                      child: Column(
                        children: [
                          AspectRatio(
                            aspectRatio: 0.8,
                            child: BarChart(
                              BarChartData(
                                alignment: BarChartAlignment.spaceAround,
                                // Dynamic maxY ensures the chart canvas expands if spending goes past $200
                                maxY: highestTotal + 50,

                                barGroups: List.generate(7, (index) {
                                  final spending = state.totals[index].total;

                                  List<Color> gradientColors;
                                  List<double> gradientStops;

                                  if (spending <= budgetLimit) {
                                    gradientColors = [Colors.blue, Colors.blue];
                                    gradientStops = [0.0, 1.0];
                                  } else {
                                    double cutOff = budgetLimit / spending;
                                    gradientColors = [
                                      Colors.blue,
                                      Colors.blue,
                                      Colors.red,
                                      Colors.red,
                                    ];
                                    gradientStops = [0.0, cutOff, cutOff, 1.0];
                                  }

                                  return BarChartGroupData(
                                    x: index,
                                    barRods: [
                                      BarChartRodData(
                                        toY: spending,
                                        width: 22,
                                        borderRadius:
                                            const BorderRadius.vertical(
                                              top: Radius.circular(4),
                                            ),
                                        gradient: LinearGradient(
                                          colors: gradientColors,
                                          stops: gradientStops,
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter,
                                        ),
                                      ),
                                    ],
                                  );
                                }),

                                extraLinesData: ExtraLinesData(
                                  horizontalLines: [
                                    HorizontalLine(
                                      y: budgetLimit,
                                      color: Colors.grey.withOpacity(0.6),
                                      strokeWidth: 2,
                                      dashArray: [5, 5],
                                    ),
                                  ],
                                ),

                                titlesData: FlTitlesData(
                                  show: true,
                                  // ENABLE AND FORMAT THE LEFT Y-AXIS
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 40,
                                      interval: 50,
                                      getTitlesWidget: (value, meta) {
                                        return SideTitleWidget(
                                          meta:
                                              meta, // Pass the meta object here instead of axisSide
                                          space: 4,
                                          child: Text(
                                            '\$${value.toInt()}',
                                            style: TextStyle(
                                              color:
                                                  value.toInt() >=
                                                      budgetLimit.toInt()
                                                  ? Colors.red
                                                  : Colors.blue,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 11,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      reservedSize: 35,
                                      showTitles: true,
                                      getTitlesWidget: (value, meta) {
                                        return SideTitleWidget(
                                          meta: meta,
                                          space:
                                              10, // 2. This safely pushes the text down away from the bars without hiding it
                                          child: Text(
                                            state.totals[value.toInt()].day,
                                            style: const TextStyle(
                                              color: Colors.black54,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  topTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  rightTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                ),

                                // ADD HORIZONTAL GRID LINES BACKING THE VALUES
                                gridData: FlGridData(
                                  show: true,
                                  drawVerticalLine: false,
                                  horizontalInterval:
                                      50, // Matches the spacing of left axis titles
                                  getDrawingHorizontalLine: (value) {
                                    return FlLine(
                                      color: Colors.grey.withOpacity(0.15),
                                      strokeWidth: 1,
                                    );
                                  },
                                ),
                                borderData: FlBorderData(show: false),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    //
                  ],
                ),
              );
            }
            return Center(child: Text("Failed to load Transactions"));
          },
        ),
      ),
    );
  }
}
