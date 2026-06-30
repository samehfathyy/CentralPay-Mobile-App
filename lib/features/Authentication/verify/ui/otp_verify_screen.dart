import 'package:budgeta/core/theming/App_Colors.dart';
import 'package:budgeta/core/theming/app_fonts.dart';
import 'package:budgeta/features/Authentication/token%20validator/token_validator_screen.dart';
import 'package:budgeta/features/Authentication/verify/cubit/otp_verify_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OtpVerifyScreen extends StatefulWidget {
  const OtpVerifyScreen({super.key});

  @override
  State<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              BlocListener<OtpVerifyCubit, OtpVerifyState>(
                listener: (context, state) async {
                  print(state);
                  if (state is OtpVerifySuccess) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TokenValidatorScreen(),
                      ),
                    );
                  }
                  if (state is OtpVerifyFailure) {
                    await showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(""),
                          content: Text(state.msg),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("OK"),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: SizedBox(),
              ),
              SizedBox(height: 5.h),
              BlocBuilder<OtpVerifyCubit, OtpVerifyState>(
                builder: (context, state) {
                  if (state is OtpVerifying) {
                    return LinearProgressIndicator(
                      minHeight: 4,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.blue),
                    );
                  }
                  return SizedBox(height: 4);
                },
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 50.h),
                        Text(
                          "Verify Your Identity",
                          style: AppFonts.black22bold,
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          "We’ve sent a 6-digit verification code to ${context.read<OtpVerifyCubit>().getEmail()}. Please enter it below to secure your account.",
                          style: AppFonts.black16,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Change Email Address",
                            style: AppFonts.blue16,
                          ),
                        ),
                        SizedBox(height: 30.h),
                        OtpCodeWidget(),
                        SizedBox(height: 20.h),
                        BlocBuilder<OtpVerifyCubit, OtpVerifyState>(
                          builder: (context, state) {
                            if (state is OtpVerifyFailure) {
                              return Center(
                                child: TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    "Resend Code",
                                    style: AppFonts.blue16,
                                  ),
                                ),
                              );
                            }
                            return SizedBox();
                          },
                        ),

                        // SizedBox(
                        //   width: double.infinity,
                        //   height: 45.h,
                        //   child: TextButton(
                        //     onPressed: () {},
                        //     child: Text("Confirm", style: AppFonts.white18),
                        //     style: TextButton.styleFrom(
                        //       backgroundColor: AppColors.basbosa,
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OtpCodeWidget extends StatefulWidget {
  const OtpCodeWidget({super.key});

  @override
  State<OtpCodeWidget> createState() => _OtpCodeWidgetState();
}

class _OtpCodeWidgetState extends State<OtpCodeWidget> {
  late bool otpCodeEnabled;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OtpVerifyCubit, OtpVerifyState>(
      builder: (context, state) {
        if (state is OtpVerifying) {
          otpCodeEnabled = false;
        } else {
          otpCodeEnabled = true;
        }
        return OtpTextField(
          borderRadius: BorderRadius.circular(12.r),
          enabled: otpCodeEnabled,
          numberOfFields: 6,
          autoFocus: true,
          showFieldAsBox: true,
          fieldWidth: 45,
          enabledBorderColor: AppColors.grey,
          focusedBorderColor: AppColors.blue,
          onSubmit: (String verificationCode) {
            // otpCodeEnabled = false;
            context.read<OtpVerifyCubit>().verify(verificationCode);
          }, // end onSubmit
        );
      },
    );
  }
}
