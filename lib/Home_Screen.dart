import 'package:budgeta/core/helpers/DateHelpers.dart';
import 'package:budgeta/core/theming/App_Colors.dart';
import 'package:budgeta/normal%20user%20features/add%20transaction/smart%20bill/overlay.dart';
import 'package:budgeta/normal%20user%20features/all%20transactions/monthly_transactions_screen.dart';
import 'package:budgeta/normal%20user%20features/profile%20page/profile_screen.dart';
import 'package:budgeta/normal%20user%20features/show%20transactions/cubit/transactions_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:budgeta/models/transaction.dart' as model;

final GlobalKey<AnimatedListState> _recentTransactionsListKey = GlobalKey();

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.fadeInKeyTotalToday});
  final Key fadeInKeyTotalToday;

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  late AnimationController fadeController;
  @override
  void initState() {
    // TODO: implement initState

    context.read<TransactionsCubit>().loadRecentTransactions();
    super.initState();
  }

  void startAnimation() {
    fadeController.reset();
    fadeController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.background,
        // appBar: AppBar(),

        // backgroundColor: Colors.black,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              foregroundColor: AppColors.white,
              automaticallyImplyLeading: false,
              shadowColor: AppColors.white,
              toolbarHeight: 60.h,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Text(
                  //   'Central',
                  //   style: AppFonts.blue24bold.copyWith(color: AppColors.green),
                  // ),
                  SizedBox(width: 2),
                  // Text('Pay', style: AppFonts.black22bold),
                  SizedBox(
                    height: 35.h,
                    child: Image(
                      image: AssetImage("assets/images/logo_text_png.png"),
                    ),
                  ),
                  Expanded(child: SizedBox()),
                  IconButton(
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileScreen(),
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.account_circle,
                      color: AppColors.greyshade700,
                      size: 34.sp,
                    ),
                  ),
                ],
              ),

              backgroundColor: AppColors.background,
            ),
            SliverToBoxAdapter(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.black,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                margin: EdgeInsets.only(top: 10.h, left: 15.w, right: 15.w),
                child: Container(
                  width: double.infinity,

                  // height: 200,
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 22.h,
                  ),
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        AppColors.purple.withOpacity(0.9),
                        AppColors.green.withOpacity(0.9),
                        // AppColors.green,
                        // Colors.grey.shade200,
                        // AppColors.purple,
                      ],
                      center: AlignmentGeometry.bottomEnd,
                      radius: 2,
                      // begin: AlignmentGeometry.topLeft,
                      // end: AlignmentGeometry.bottomRight,
                    ),
                    border: Border.all(color: AppColors.lightgrey, width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.grey.withOpacity(0.1),
                        blurRadius: 3,
                        spreadRadius: 3,
                        offset: Offset(0, 4),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child:
                      BlocSelector<
                        TransactionsCubit,
                        TransactionsState,
                        TotalExpenseAndIncome
                      >(
                        selector: (state) => state.totalExpenseAndIncome,
                        builder: (context, totalExpenseAndIncome) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total Today',
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 5.h),
                              // Text(
                              //   '\$5,000.00',
                              //   style: TextStyle(
                              //     color: AppColors.black,
                              //     fontSize: 30.sp,
                              //     fontWeight: FontWeight.bold,
                              //   ),
                              // ),
                              // SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  incomeandoutcome(
                                    true,
                                    totalExpenseAndIncome.totalIncome,
                                  ),
                                  incomeandoutcome(
                                    false,
                                    totalExpenseAndIncome.totalExpense,
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                ),
              ),
            ),
            //header text transactions
            SliverAppBar(
              automaticallyImplyLeading: false,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Transactions',
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MonthlyTransactionsScreen(),
                        ),
                      );
                    },
                    child: Text(
                      "Show All",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.blue,
                      ),
                    ),
                  ),
                ],
              ),
              pinned: true,

              backgroundColor: AppColors.background,
            ),
            //transactions
            BlocBuilder<TransactionsCubit, TransactionsState>(
              builder: (context, state) {
                final transactions = state.recentTransactions;
                if (transactions.isNotEmpty) {
                  return SliverList.builder(
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = transactions[index];
                      return TransactionTile(transaction: transaction);
                    },
                  );
                }
                //no transactions
                return SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 40.h),
                      child: Text("No Recent Transactions"),
                    ),
                  ),
                );
              },
            ),
            SliverToBoxAdapter(child: SizedBox(height: 100.h)),
          ],
        ),
        floatingActionButton: GestureDetector(
          onLongPressStart: (details) {
            print('button is held');
          },
          onLongPressEnd: (details) {
            print("button is released");
          },
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ScanningOverlay()),
            );
          },
          child: Container(
            // margin: EdgeInsets.only(top: 25),
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.blue,
              // color: AppColors.black.withOpacity(0.1),
              shape: BoxShape.circle,
              //border: Border.all(width: 2, color: AppColors.lightgrey),
              // boxShadow: [
              //   BoxShadow(
              //     color: AppColors.primary.withOpacity(0.3),
              //     blurRadius: 3,
              //     spreadRadius: 1,
              //   ),
              // ],
            ),
            child: Icon(
              Icons.document_scanner,
              size: 30.sp,
              color: AppColors.white,
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}

Widget incomeandoutcome(bool isIncome, double amount) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Row(
        children: [
          Icon(
            isIncome ? Icons.call_received_outlined : Icons.call_made_outlined,
            color: AppColors.white,
          ),
          SizedBox(width: 4),
          Text(
            isIncome ? 'Income' : 'Expense',
            style: TextStyle(color: AppColors.white, fontSize: 18.sp),
          ),
        ],
      ),
      Text(
        ' \$ ${amount == 0 ? "0" : amount}',
        style: TextStyle(
          color: isIncome ? Colors.white : AppColors.white,
          fontSize: 22.sp,
        ),
      ),
    ],
  );
}

class TransactionTile extends StatelessWidget {
  const TransactionTile({super.key, required this.transaction});
  final model.Transaction transaction;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: Key(transaction.id.toString()),

      endActionPane: ActionPane(
        motion: const StretchMotion(),
        extentRatio: 0.25,
        children: [
          SlidableAction(
            onPressed: (_) async {
              // print("deleted");
              await context.read<TransactionsCubit>().deleteTransaction(
                transaction.id,
              );
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            // borderRadius: BorderRadius.circular(16.r),
            icon: Icons.delete,
            label: 'Delete',
            spacing: 2,
            autoClose: true,
          ),
        ],
      ),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
        padding: EdgeInsets.symmetric(vertical: 12.w, horizontal: 15.w),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          children: [
            Icon(
              transaction.category.isExpense
                  ? Icons.call_made_outlined
                  : Icons.call_received_outlined,

              color: AppColors.black,
              // color: transaction.category.isExpense
              //     ? AppColors.red
              //     : AppColors.green,
              size: 30.sp,
            ),

            SizedBox(width: 15),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //title
                Text(
                  transaction.category.name.toString(),
                  style: TextStyle(color: AppColors.black, fontSize: 16.sp),
                ),
                Text(
                  transaction.datetime.toDateFormat_11jan2025(),
                  style: TextStyle(color: Color.fromARGB(255, 56, 56, 56)),
                ),
              ],
            ),

            Expanded(child: SizedBox()),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$ ${transaction.amount.toInt()}',
                  style: TextStyle(
                    color: transaction.category.isExpense
                        ? AppColors.red
                        : Colors.green,
                    fontSize: 20.sp,
                  ),
                ),

                // Text(
                //   '${transactions[index].datetime.toDateFormat_11jan2025()}',
                //   style: TextStyle(color: AppColors.black),
                // ),
              ],
            ),
            SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}
