import 'package:budgeta/core/theming/App_Colors.dart';
import 'package:budgeta/core/theming/app_fonts.dart';
import 'package:budgeta/features/Authentication/sign%20in/signin_screen.dart';
import 'package:budgeta/features/Authentication/sign%20up/cubit/sign_up_cubit.dart';
import 'package:budgeta/features/Authentication/sign%20up/data/models/signup_request.dart';
import 'package:budgeta/features/Authentication/verify/ui/otp_verify_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  late TextEditingController _nameTextEditingController;
  late TextEditingController _emailTextEditingController;
  late TextEditingController _passwordTextEditingController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nameTextEditingController = TextEditingController();
    _emailTextEditingController = TextEditingController();
    _passwordTextEditingController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _nameTextEditingController.dispose();
    _emailTextEditingController.dispose();
    _passwordTextEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              BlocListener<SignUpCubit, SignUpState>(
                child: SizedBox(),
                listener: (context, state) async {
                  if (state is SignUpSuccess) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OtpVerifyScreen(),
                      ),
                    );
                  }
                  if (state is SignUpError) {
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
              ),
              BlocBuilder<SignUpCubit, SignUpState>(
                builder: (context, state) {
                  // bool isErrorOrInitial =
                  //     state is SignUpInitial || state is SignUpError;
                  bool isSigningUp = state is SigningUp;
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 40.h),
                        Text(
                          "Create Account",
                          style: AppFonts.black22bold.copyWith(
                            fontSize: 30.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 20.h),
                        CustomTextField(
                          controller: _nameTextEditingController,
                          hintText: "name",
                          textInputType: TextInputType.name,
                        ),
                        SizedBox(height: 10.h),
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
                        SizedBox(height: 20.h),
                        Center(
                          child: InkWell(
                            onTap: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SigninScreen(),
                                ),
                                (route) => false,
                              );
                            },
                            child: Text(
                              "Already have an account? Sign In",
                              style: AppFonts.blue16,
                            ),
                          ),
                        ),
                        SizedBox(height: 20.h),

                        SizedBox(
                          width: double.infinity,
                          height: 45.h,
                          child: TextButton(
                            onPressed: isSigningUp
                                ? () {}
                                : () async {
                                    SignupRequest signupRequest = SignupRequest(
                                      name: _nameTextEditingController.text,
                                      email: _emailTextEditingController.text,
                                      password:
                                          _passwordTextEditingController.text,
                                    );
                                    await context.read<SignUpCubit>().signup(
                                      signupRequest,
                                    );
                                  },
                            style: TextButton.styleFrom(
                              backgroundColor: AppColors.blue,
                            ),
                            child: isSigningUp
                                ? Center(
                                    child:
                                        LoadingAnimationWidget.horizontalRotatingDots(
                                          color: AppColors.white,
                                          size: 35,
                                        ),
                                  )
                                : Text("Sign Up", style: AppFonts.white18),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PasswordTextField extends StatefulWidget {
  const PasswordTextField({super.key, required this.controller});
  final TextEditingController controller;
  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool isObscureText = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: isObscureText,
      decoration: InputDecoration(
        // prefixIcon: widget.preFixIcon,
        errorMaxLines: 3,
        errorStyle: TextStyle(fontSize: 14.sp),
        alignLabelWithHint: false,
        isDense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.black, width: 1.3),
          borderRadius: BorderRadius.circular(14.r),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.grey, width: 2),
          borderRadius: BorderRadius.circular(14.r),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red, width: 1.3),
          borderRadius: BorderRadius.circular(14.r),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red, width: 1.3),
          borderRadius: BorderRadius.circular(14.r),
        ),
        // hintStyle: widget.hintStyle ?? TextStyles.textformfont,
        hintText: "password",
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              isObscureText = !isObscureText;
            });
          },
          icon: isObscureText
              ? Icon(Icons.visibility_off, size: 20.sp)
              : Icon(Icons.visibility, size: 20.sp),
        ),
        fillColor: AppColors.white,
        filled: true,
      ),
    );
  }
}

class CustomTextField extends StatefulWidget {
  CustomTextField({
    super.key,
    required this.controller,
    this.hintText,
    this.textInputType,
  });
  final TextEditingController controller;
  String? hintText = "";
  TextInputType? textInputType;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.textInputType,
      decoration: InputDecoration(
        // prefixIcon: widget.preFixIcon,
        errorMaxLines: 3,
        errorStyle: TextStyle(fontSize: 14.sp),
        alignLabelWithHint: false,
        isDense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.black, width: 1.3),
          borderRadius: BorderRadius.circular(14.r),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.grey, width: 2),
          borderRadius: BorderRadius.circular(14.r),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red, width: 1.3),
          borderRadius: BorderRadius.circular(14.r),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red, width: 1.3),
          borderRadius: BorderRadius.circular(14.r),
        ),
        // hintStyle: widget.hintStyle ?? TextStyles.textformfont,
        hintText: widget.hintText,

        fillColor: AppColors.white,
        filled: true,
      ),
    );
  }
}
