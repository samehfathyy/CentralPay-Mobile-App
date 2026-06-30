import 'package:budgeta/business%20features/select%20sms%20provider/select_sms_providers_screen.dart';
import 'package:budgeta/business%20features/sync%20SMS/data/cubit/sms_sync_cubit.dart';
import 'package:budgeta/core/theming/App_Colors.dart';
import 'package:budgeta/core/theming/app_fonts.dart';
import 'package:budgeta/features/switch%20app%20mode/cubit/app_mode_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class BusinessHomeScreen extends StatefulWidget {
  const BusinessHomeScreen({super.key});

  @override
  State<BusinessHomeScreen> createState() => _BusinessHomeScreenState();
}

class _BusinessHomeScreenState extends State<BusinessHomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<SmsSyncCubit>().init();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Business Mode", style: AppFonts.black18),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              onPressed: () async {
                context.read<AppModeCubit>().setAppModeToNormal();
              },
              icon: Icon(Icons.swap_horiz, color: AppColors.black),
            ),
          ],
        ),
        body: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            BlocListener<SmsSyncCubit, SmsSyncState>(
              listenWhen: (previous, current) {
                return current is SmsSyncError;
              },
              listener: (context, state) async {
                if (state is SmsSyncError) {
                  if (state.caseCode ==
                      SyncProblemsCases.noProviderSelectedYet) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SelectSmsProvidersScreen(),
                      ),
                    );
                    return;
                  }
                  if (state.caseCode == SyncProblemsCases.smsAccessDenied) {
                    await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text("Access to SMS Messages is Denied"),
                        content: Text(
                          "Please grant access to SMS messages and try syncing again.",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () async {
                              Navigator.pop(context);
                              await Future.delayed(Duration(milliseconds: 500));
                              await Permission.sms.request();
                            },
                            child: Text("OK"),
                          ),
                        ],
                      ),
                    );
                    return;
                  }
                  if (state.caseCode == SyncProblemsCases.noMessagesFound) {
                    await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text("No SMS Messages Found"),
                        content: Text(
                          "It seems that you have no SMS messages in your inbox. Please make sure you have SMS messages and try syncing again.",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("OK"),
                          ),
                        ],
                      ),
                    );
                    return;
                  }
                }
              },
              child: SizedBox(),
            ),
            BlocBuilder<SmsSyncCubit, SmsSyncState>(
              builder: (context, state) {
                // int lastSyncEpoch =
                //     await context.read<SmsSyncCubit>().getLastSyncEpochDate() ??
                // 0;
                // return SizedBox();
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20.h),
                      Center(
                        child: Text(
                          "Device name: ${context.read<SmsSyncCubit>().deviceName}",
                          style: AppFonts.black18,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        "Last Sync: ${context.read<SmsSyncCubit>().lastSyncDate}",
                        style: AppFonts.black18,
                      ),
                      SizedBox(height: 20.h),
                    ],
                  ),
                );
              },
            ),
            // TextButton(
            //   onPressed: () {
            //     // context.read<SelectSmsProviderCubit>().init();
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => SelectSmsProvidersScreen(),
            //       ),
            //     );
            //   },
            //   child: Text("select sms"),
            // ),
            ListTile(
              title: Text("Select SMS Provider", style: AppFonts.black18),
              trailing: Icon(Icons.arrow_forward_ios, color: AppColors.black),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SelectSmsProvidersScreen(),
                  ),
                );
              },
            ),
            SizedBox(height: 20.h),
            BlocBuilder<SmsSyncCubit, SmsSyncState>(
              builder: (context, state) {
                if (state is SmsSyncUploading) {
                  return CircularProgressIndicator();
                }
                if (state is SmsSyncSuccess) {
                  return Text("Sync completed successfully!");
                }
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () {
                        context.read<SmsSyncCubit>().Fetch();
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: AppColors.blue,
                      ),
                      child: Text("Sync Now", style: AppFonts.white18),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 15.h),
            TextButton(
              onPressed: () {
                context.read<SmsSyncCubit>().clearLastSyncEpochDate();
              },
              child: Text("Clear Last Sync Date", style: AppFonts.blue16),
            ),
            // spacerLine(5),
            // //https://centralpay-phi.vercel.app/
            // TextButton(
            //   onPressed: () async {
            //     await openBrowserLink("https://centralpay-phi.vercel.app/");
            //   },
            //   child: Text("Visit CentralPay Website", style: AppFonts.blue16),
            // ),
          ],
        ),
      ),
    );
  }
}

Future<void> openBrowserLink(String urlString) async {
  final Uri url = Uri.parse(urlString);

  // Check if the device has an app capable of launching this URL
  if (await canLaunchUrl(url)) {
    await launchUrl(
      url,
      // mode: LaunchMode.externalApplication forces it out into Chrome/Safari
      // instead of keeping it trapped inside an in-app webview wrapper.
      mode: LaunchMode.externalApplication,
    );
  } else {
    throw 'Could not launch $urlString';
  }
}
