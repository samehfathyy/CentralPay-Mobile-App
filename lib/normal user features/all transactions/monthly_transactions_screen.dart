import 'dart:ui';

import 'package:animate_do/animate_do.dart';
import 'package:budgeta/Home_Screen.dart';
import 'package:budgeta/core/helpers/DateHelpers.dart';
import 'package:budgeta/core/theming/App_Colors.dart';
import 'package:budgeta/normal%20user%20features/all%20transactions/cubit/monthly_transacrions_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MonthlyTransactionsScreen extends StatefulWidget {
  const MonthlyTransactionsScreen({super.key});

  @override
  State<MonthlyTransactionsScreen> createState() =>
      _MonthlyTransactionsScreenState();
}

class _MonthlyTransactionsScreenState extends State<MonthlyTransactionsScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<MonthlyTransacrionsCubit>().loadMonthlyTransactions(
      DateTime.now(),
    );
  }

  String selected = "all";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Monthly Transactions", style: TextStyle(fontSize: 18.sp)),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.white,
      ),
      body: Stack(
        alignment: AlignmentGeometry.bottomCenter,
        children: [
          Column(
            children: [
              Padding(
                padding: EdgeInsets.all(5.w),
                child: Row(
                  children: [
                    Expanded(
                      child: SegmentedButton<String>(
                        selected: {selected},
                        segments: [
                          ButtonSegment(
                            value: "all",
                            label: Text(
                              "All",
                              style: TextStyle(
                                fontSize: 16.sp,
                                // color: isExpense ? Colors.black : Colors.white,
                              ),
                            ),
                          ),
                          ButtonSegment(
                            value: "expense",
                            label: Text(
                              "Expense",
                              style: TextStyle(
                                fontSize: 16.sp,
                                // color: isExpense ? Colors.black : Colors.white,
                              ),
                            ),
                          ),
                          ButtonSegment(
                            value: "income",
                            label: Text(
                              "Income",
                              style: TextStyle(
                                fontSize: 16.sp,
                                // color: isExpense ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        ],
                        onSelectionChanged: (Set<String> newSelection) {
                          setState(() {
                            selected = newSelection.first;
                          });
                          print(".$selected.");
                          context
                              .read<MonthlyTransacrionsCubit>()
                              .selectTransactionType(selected);
                        },
                        showSelectedIcon: false,
                        style: SegmentedButton.styleFrom(
                          // selectedForegroundColor: AppColors.blue,
                          backgroundColor: Color.fromARGB(58, 83, 83, 83),
                          selectedBackgroundColor: AppColors.white,

                          side: BorderSide(color: Colors.transparent),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child:
                    BlocBuilder<
                      MonthlyTransacrionsCubit,
                      MonthlyTransacrionsState
                    >(
                      builder: (context, state) {
                        if (state is MonthlyTransacrionsLoading) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (state is MonthlyTransacrionsLoaded) {
                          if (state.transactions.isEmpty) {
                            return Padding(
                              padding: EdgeInsets.only(
                                left: 10.w,
                                right: 10.w,
                                bottom: 50,
                              ),
                              child: Center(
                                child: Text(
                                  "There are no Transactions recorded for the selected month.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: AppColors.darkgrey,
                                  ),
                                ),
                              ),
                            );
                          }
                          return ListView.builder(
                            itemCount: state.transactions.length,
                            itemBuilder: (context, index) {
                              //last element
                              if (index == state.transactions.length - 1) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 100),
                                  child: FadeInUp(
                                    delay: Duration(milliseconds: 100 * index),
                                    duration: Duration(milliseconds: 400),
                                    from: 10,
                                    child: TransactionTile(
                                      transaction: state.transactions[index],
                                    ),
                                  ),
                                );
                              }
                              return FadeInUp(
                                delay: Duration(milliseconds: 100 * index),
                                duration: Duration(milliseconds: 400),
                                from: 10,

                                child: TransactionTile(
                                  transaction: state.transactions[index],
                                ),
                              );
                            },
                          );
                        }
                        return SizedBox();
                      },
                    ),
              ),
            ],
          ),
          MonthSelectSlide(
            oncallback: (DateTime dt) {
              context.read<MonthlyTransacrionsCubit>().loadMonthlyTransactions(
                dt,
              );
            },
          ),
        ],
      ),
    );
  }
}

class MonthSelectSlide extends StatefulWidget {
  const MonthSelectSlide({super.key, required this.oncallback});
  final Function(DateTime dt) oncallback;
  @override
  State<MonthSelectSlide> createState() => _MonthSelectSlideState();
}

class _MonthSelectSlideState extends State<MonthSelectSlide> {
  late DateTime dt;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dt = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(15.w),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.5),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      dt = DateTime(dt.year, dt.month - 1, 1);
                    });
                    widget.oncallback(dt);
                  },
                  icon: Icon(Icons.arrow_back_ios_rounded),
                ),
                Text(
                  "${dt.getMonthName()} ${dt.year}",
                  style: TextStyle(fontSize: 16.sp),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      dt = DateTime(dt.year, dt.month + 1, 1);
                    });
                    widget.oncallback(dt);
                  },
                  icon: Icon(Icons.arrow_forward_ios_rounded),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
