import 'package:animate_do/animate_do.dart';
import 'package:budgeta/core/theming/App_Colors.dart';
import 'package:budgeta/core/theming/app_fonts.dart';
import 'package:budgeta/features/Authentication/sign%20up/ui/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,

              children: [
                SizedBox(height: 20.h),
                // Image( "/images/logo.png", width: 250.w, height: 250.h),
                SizedBox(
                  height: screenwidth - 10,
                  child: FadeIn(
                    duration: Duration(milliseconds: 1500),
                    child: Image(
                      image: AssetImage("assets/images/Central.png"),
                    ),
                  ),
                ),
                // Row(
                //   children: [
                //     SizedBox(width: 15.w),
                //     Text(
                //       "Your Money\nYour Control",
                //       style: AppFonts.black22.copyWith(
                //         fontWeight: FontWeight.w700,
                //         fontSize: 34.sp,
                //       ),
                //     ),
                //   ],
                // ),
                // SizedBox(height: 20.h),
                // FadeInUp(
                //   child: Row(
                //     children: [
                //       SizedBox(width: 15.w),
                //       Text(
                //         """Manage Everything in One Place.\nTrack Your Money Effortlessly.\nUnderstand Your Spending.""",
                //         style: AppFonts.grey16.copyWith(
                //           fontSize: 18.sp,
                //           height: 1.8,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FadeInUp(
                      delay: Duration(milliseconds: 300),
                      from: 20,
                      child: Text(
                        "Manage Everything in One Place.",
                        style: AppFonts.grey16.copyWith(
                          fontSize: 18.sp,
                          height: 1.8,
                        ),
                      ),
                    ),

                    FadeInUp(
                      delay: Duration(milliseconds: 600),
                      from: 20,
                      child: Text(
                        "Track Your Money Effortlessly.",
                        style: AppFonts.grey16.copyWith(
                          fontSize: 18.sp,
                          height: 1.8,
                        ),
                      ),
                    ),
                    FadeInUp(
                      delay: Duration(milliseconds: 900),
                      from: 20,
                      child: Text(
                        "Understand Your Spending.",
                        style: AppFonts.grey16.copyWith(
                          fontSize: 18.sp,
                          height: 1.8,
                        ),
                      ),
                    ),
                  ],
                ),

                Expanded(child: SizedBox()),
                // SizedBox(height: 100.h),
                SizedBox(
                  width: double.infinity,
                  height: 50.h,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: AppColors.black,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignupScreen()),
                      );
                    },
                    child: Text(
                      "Get Started",
                      style: AppFonts.white18.copyWith(fontSize: 20.sp),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: AppColors.white,
    );
  }
}
