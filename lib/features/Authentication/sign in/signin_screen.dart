import 'package:budgeta/core/theming/App_Colors.dart';
import 'package:budgeta/core/theming/app_fonts.dart';
import 'package:budgeta/features/Authentication/sign%20in/cubit/sign_in_cubit.dart';
import 'package:budgeta/features/Authentication/sign%20in/data/signin_request.dart';
import 'package:budgeta/features/Authentication/sign%20up/ui/signup_screen.dart';
import 'package:budgeta/features/Authentication/token%20validator/token_validator_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  late TextEditingController _emailTextEditingController;
  late TextEditingController _passwordTextEditingController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _emailTextEditingController = TextEditingController();
    _passwordTextEditingController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _emailTextEditingController.dispose();
    _passwordTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppColors.blue,
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              BlocListener<SignInCubit, SignInState>(
                child: SizedBox(),
                listener: (context, state) async {
                  print(state);
                  if (state is SignInSuccess) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TokenValidatorScreen(),
                      ),
                    );
                  }
                  if (state is SignInFailure) {
                    await showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(""),
                          content: Text(state.message),
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
              ),
              //
              BlocBuilder<SignInCubit, SignInState>(
                builder: (context, state) {
                  // bool isErrorOrInitial =
                  //     state is SignUpInitial || state is SignUpError;
                  bool isSigningIn = state is SignInLoading;
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // SizedBox(height: 50.h),

                        // SizedBox(
                        //   height: 50,
                        //   child: Image(
                        //     image: AssetImage(
                        //       "assets/images/logo_text_png.png",
                        //     ),
                        //   ),
                        // ),
                        SizedBox(height: 40.h),

                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 15.w,
                            vertical: 20.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18.r),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Welcome Back",
                                    style: AppFonts.black22bold.copyWith(
                                      fontSize: 30.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 15.h),
                              CustomTextField(
                                controller: _emailTextEditingController,
                                hintText: "email",
                                textInputType: TextInputType.emailAddress,
                              ),
                              SizedBox(height: 10.h),
                              PasswordTextField(
                                controller: _passwordTextEditingController,
                              ),
                              // isError?Text("Wrong Password or Email",style: AppFonts.red16,):SizedBox(),
                              SizedBox(height: 40.h),
                              Center(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SignupScreen(),
                                      ),
                                      (route) => false,
                                    );
                                  },
                                  child: Text(
                                    "Don't have an account? Create one",
                                    style: AppFonts.blue16,
                                  ),
                                ),
                              ),
                              SizedBox(height: 15.h),

                              SizedBox(
                                width: double.infinity,
                                height: 50.h,
                                child: TextButton(
                                  onPressed: isSigningIn
                                      ? () {}
                                      : () async {
                                          SignInRequest
                                          signinRequest = SignInRequest(
                                            email: _emailTextEditingController
                                                .text,
                                            password:
                                                _passwordTextEditingController
                                                    .text,
                                          );
                                          await context
                                              .read<SignInCubit>()
                                              .signIn(signinRequest);
                                        },
                                  style: TextButton.styleFrom(
                                    backgroundColor: AppColors.blue,
                                  ),
                                  child: isSigningIn
                                      ? Center(
                                          child:
                                              LoadingAnimationWidget.horizontalRotatingDots(
                                                color: AppColors.white,
                                                size: 35,
                                              ),
                                        )
                                      : Text(
                                          "Sign In",
                                          style: AppFonts.white18,
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              //
            ],
          ),
        ),
      ),
    );
  }
}
