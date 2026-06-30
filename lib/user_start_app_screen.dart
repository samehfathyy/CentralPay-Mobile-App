import 'dart:math';

import 'package:budgeta/Home_Screen.dart';
import 'package:budgeta/core/theming/App_Colors.dart';
import 'package:budgeta/normal%20user%20features/add%20transaction/ui/add_transaction_screen.dart';
import 'package:budgeta/normal%20user%20features/budget%20limit/budget_screen.dart';
import 'package:budgeta/normal%20user%20features/budget%20limit/cubit/budget_limit_cubit.dart';
import 'package:budgeta/normal%20user%20features/profile%20page/profile_screen.dart';
import 'package:budgeta/normal%20user%20features/statistics/statistics_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserStartAppScreen extends StatefulWidget {
  const UserStartAppScreen({super.key});

  @override
  State<UserStartAppScreen> createState() => _UserStartAppScreenState();
}

class _UserStartAppScreenState extends State<UserStartAppScreen> {
  Key fadeInKeyTotalToday = UniqueKey();
  Key fadeInKeyStatistics = UniqueKey();
  Key fadeInKeyStatistics2 = UniqueKey();
  int _selectedIndex = 0;
  late double iconSize;
  void navigateToScreen(int newIndex) {
    newIndex == 2 ? context.read<BudgetLimitCubit>().loadTransactions() : null;
    if (newIndex == _selectedIndex) {
      return;
    }
    setState(() {
      _selectedIndex = newIndex;
      newIndex == 0 ? fadeInKeyTotalToday = UniqueKey() : null;
      newIndex == 1 ? fadeInKeyStatistics = UniqueKey() : null;
      newIndex == 1 ? fadeInKeyStatistics2 = UniqueKey() : null;
    });
  }

  Widget navIcon(IconData icon, int index) {
    return IconButton(
      onPressed: () {
        navigateToScreen(index);
      },
      highlightColor: Colors.transparent,
      padding: EdgeInsets.zero,
      icon: Icon(
        icon,
        color: _selectedIndex == index ? AppColors.blue : AppColors.grey,
        size: iconSize ?? 30.sp,
      ),
    );
  }

  Widget addTransactionButton(void Function(int i) oncallback) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                AddTransactionScreen(onSaveCallBack: oncallback),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  // Offset(0, 1) is the bottom of the screen
                  // Offset(0, 0) is the center of the screen
                  const begin = Offset(0.0, 1.0);
                  const end = Offset.zero;
                  const curve = Curves.easeInOut;

                  var tween = Tween(
                    begin: begin,
                    end: end,
                  ).chain(CurveTween(curve: curve));
                  var offsetAnimation = animation.drive(tween);

                  return SlideTransition(
                    position: offsetAnimation,
                    child: child,
                  );
                },
            // Adjust the speed here (e.g., 500ms)
            transitionDuration: const Duration(milliseconds: 400),
          ),
        );
        // oncallback(0);
      },
      child: Container(
        width: 45.w,
        height: 45.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.green,
        ),
        child: Icon(Icons.add, color: AppColors.white, size: 30.sp),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    iconSize = min(30.sp, 35);
    double screenWidth = MediaQuery.of(context).size.width;
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          alignment: Alignment.center,
          children: [
            IndexedStack(
              index: _selectedIndex,
              children: [
                HomeScreen(fadeInKeyTotalToday: fadeInKeyTotalToday),
                StatisticsScreen(
                  fadeInKey: fadeInKeyStatistics,
                  fadeInKey2: fadeInKeyStatistics2,
                ),
                BudgetScreen(),
                ProfileScreen(),
              ],
            ),
            // Container(color: Colors.black.withAlpha(155)),
          ],
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            // borderRadius: BorderRadius.circular(100.r),
            // border: Border.all(width: 2, color: AppColors.lightgrey),
            // border: Border(top: BorderSide(width: 2, color: AppColors.lightgrey)),
            boxShadow: [
              BoxShadow(
                color: AppColors.grey.withOpacity(0.2),
                blurRadius: 2,
                spreadRadius: 1,
              ),
            ],
          ),
          width: screenWidth,
          // padding: EdgeInsets.only(top: 5),
          child: SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                navIcon(Icons.home_filled, 0),
                navIcon(Icons.bar_chart, 1),
                addTransactionButton(navigateToScreen),
                // Container(width: 60, height: 60, color: Colors.transparent),
                navIcon(Icons.wallet_rounded, 2),
                navIcon(Icons.person, 3),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
