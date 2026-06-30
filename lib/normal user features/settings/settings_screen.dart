import 'package:budgeta/core/theming/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Daily Budget", style: AppFonts.black20),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Column(
          children: [
            // InkWell(
            //   onTap: () async {
            //     context.read<AppModeCubit>().setAppModeToBusiness();
            //   },
            //   child: SizedBox(
            //     width: double.infinity,
            //     child: Padding(
            //       padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
            //       child: Row(
            //         children: [
            //           Icon(Icons.swap_horiz_sharp, size: 28.sp),
            //           SizedBox(width: 10),
            //           Text("Switch to Business Mode", style: AppFonts.black18),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
            SizedBox(height: 10.h),
            InkWell(
              onTap: () {},
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Change Budget Limit", style: AppFonts.black18),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        // color: AppColors.blue,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Text("change    ", style: AppFonts.blue14),
                          Text(
                            "50",
                            style: AppFonts.black20.copyWith(
                              fontWeight: FontWeight.w600,
                              // color: Colors.blue,
                            ),
                          ),
                          // Icon(Icons.change, size: 30),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10.h),
            Container(color: Colors.amber, height: 320),
          ],
        ),
      ),
    );
  }
}
