import 'package:budgeta/core/theming/App_Colors.dart';
import 'package:budgeta/core/theming/app_fonts.dart';
import 'package:budgeta/features/Authentication/sign%20in/signin_screen.dart';
import 'package:budgeta/features/Authentication/token%20validator/cubit/token_validator_cubit.dart';
import 'package:budgeta/features/switch%20app%20mode/app_mode_switch_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class TokenValidatorScreen extends StatefulWidget {
  const TokenValidatorScreen({super.key});

  @override
  State<TokenValidatorScreen> createState() => _TokenValidatorScreenState();
}

class _TokenValidatorScreenState extends State<TokenValidatorScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<TokenValidatorCubit>().validateTokenAndCheckInternet();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TokenValidatorCubit, TokenValidatorState>(
      builder: (context, state) {
        if (state is TokenValid) {
          return AppModeSwitchScreen();
        }
        if (state is TokenNotValid) {
          return Scaffold(
            body: SafeArea(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: Column(
                    // mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Icon(Icons.wifi_off, color: AppColors.red, size: 50),
                      SizedBox(height: 10.h),
                      Text("Your Login Session ended", style: AppFonts.black18),
                      // SizedBox(height: 40.h),
                      SizedBox(
                        width: double.infinity,
                        height: 45.h,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: AppColors.blue,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SigninScreen(),
                              ),
                            );
                          },
                          child: Text("Sign In", style: AppFonts.white18),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
        if (state is NoInternetConncetion) {
          return Scaffold(
            body: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.wifi_off, color: AppColors.red, size: 50),
                    SizedBox(height: 10.h),
                    Text("No internet Connection", style: AppFonts.red16),
                    SizedBox(height: 40.h),
                    SizedBox(
                      width: double.infinity,
                      // height: 50.h,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: AppColors.blue,
                        ),
                        onPressed: () {
                          context
                              .read<TokenValidatorCubit>()
                              .validateTokenAndCheckInternet();
                        },
                        child: Text("Retry", style: AppFonts.white18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return Scaffold(
          body: Center(
            child: LoadingAnimationWidget.hexagonDots(
              color: AppColors.blue,
              size: 40,
            ),
          ),
        );
      },
    );
  }
}
