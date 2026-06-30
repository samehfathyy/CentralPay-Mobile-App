import 'package:animate_do/animate_do.dart';
import 'package:budgeta/core/theming/App_Colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BusinessSplashScreen extends StatelessWidget {
  const BusinessSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blue,
      // appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            FadeInLeft(
              child: Text(
                "CentralPay  ",
                style: TextStyle(
                  fontSize: 32.sp,
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            FadeInRight(
              delay: Duration(milliseconds: 500),
              child: Text(
                "Business",
                style: TextStyle(
                  fontSize: 24.sp,
                  color: AppColors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
