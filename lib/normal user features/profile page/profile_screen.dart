import 'package:budgeta/core/constansts/shared_pref_cons.dart';
import 'package:budgeta/core/dependency_injection.dart';
import 'package:budgeta/core/helpers/ui_helpers.dart';
import 'package:budgeta/core/network/dio_factory.dart';
import 'package:budgeta/core/theming/App_Colors.dart';
import 'package:budgeta/core/theming/app_fonts.dart';
import 'package:budgeta/features/Authentication/auth_repo.dart';
import 'package:budgeta/features/Authentication/sign%20in/signin_screen.dart';
import 'package:budgeta/features/backup%20transactions/cubit/backup_transactions_cubit.dart';
import 'package:budgeta/features/restore%20transactions/cubit/cubit/restore_transactions_cubit.dart';
import 'package:budgeta/features/switch%20app%20mode/cubit/app_mode_cubit.dart';
import 'package:budgeta/main.dart';
import 'package:budgeta/normal%20user%20features/add%20transaction/cubit/cubit/add_transaction_cubit.dart';
import 'package:budgeta/normal%20user%20features/show%20transactions/cubit/transactions_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});
  double titleWidth = 95.w;
  double tilePadding = 18.w;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Profile", style: AppFonts.black20),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 30.h),
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey.shade400,
                  child: Icon(Icons.person, size: 50, color: Colors.white),
                ),
              ),
              SizedBox(height: 12.h),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.edit, color: Colors.transparent),
                  ),
                  Text(
                    getIt<AuthRepo>().userDataResponse?.data?.name ?? "",
                    style: AppFonts.black22,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.edit, color: AppColors.blue),
                  ),
                ],
              ),
              Row(
                children: [
                  SizedBox(width: 20.w),
                  Text("Personal Information", style: AppFonts.grey16),
                ],
              ),
              SizedBox(height: 12.h),
              spacerLine(),
              ListTile(
                onTap: () {},
                // title: Text("Email"),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: titleWidth,
                      child: Text(
                        "Email",
                        style: AppFonts.black18,
                        maxLines: 1,
                        // overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        getIt<AuthRepo>().userDataResponse?.data?.email ?? "",
                        style: AppFonts.grey16,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                tileColor: AppColors.white,
                // trailing: Icon(Icons.edit, color: AppColors.blue),
                contentPadding: EdgeInsets.symmetric(horizontal: tilePadding),
              ),
              spacerLine(),
              ListTile(
                onTap: () {},
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: titleWidth,
                      child: Text(
                        "Phone",
                        style: AppFonts.black18,
                        maxLines: 1,
                        // overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "01204403398",
                        style: AppFonts.grey16,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                tileColor: AppColors.white,

                // trailing: Icon(Icons.edit, color: AppColors.blue),
                contentPadding: EdgeInsets.symmetric(horizontal: tilePadding),
              ),
              spacerLine(),
              ListTile(
                onTap: () {},
                // title: Text("Email"),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: titleWidth,
                      child: Text(
                        "Birthday",
                        style: AppFonts.black18,
                        maxLines: 2,
                        // overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      "1/9/2004",
                      style: AppFonts.grey16,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                tileColor: AppColors.white,

                // trailing: Icon(Icons.edit, color: AppColors.grey),
                contentPadding: EdgeInsets.symmetric(horizontal: tilePadding),
              ),
              spacerLine(),

              // spacerLine(),
              SizedBox(height: 12.h),

              Row(
                children: [
                  SizedBox(width: 20.w),
                  Text("Settings", style: AppFonts.grey16),
                ],
              ),
              SizedBox(height: 12.h),

              // spacerLine(),
              spacerLine(),
              BlocListener<RestoreTransactionsCubit, RestoreTransactionsState>(
                listener: (context, state) {
                  if (state is RestoreTransactionsSuccess) {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(""),
                          content: Text("Transactions restored successfully"),
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
                child: SizedBox.shrink(),
              ),
              BlocListener<BackupTransactionsCubit, BackupTransactionsState>(
                listener: (context, state) async {
                  if (state is BackupTransactionsSuccess) {
                    await showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(""),
                          content: Text("Transactions backed up successfully"),
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
                child: SizedBox.shrink(),
              ),
              BlocBuilder<RestoreTransactionsCubit, RestoreTransactionsState>(
                builder: (context, state) {
                  if (state is RestoreTransactionsLoading) {
                    return ListTile(
                      onTap: () {},
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            child: Text(
                              "Restoring Transactions...",
                              style: AppFonts.black18,
                              maxLines: 2,
                              // overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      trailing: LoadingAnimationWidget.threeArchedCircle(
                        color: Colors.black,
                        size: 18.sp,
                      ),
                      tileColor: AppColors.white,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: tilePadding,
                      ),
                    );
                  }
                  return ListTile(
                    onTap: () async {
                      await context
                          .read<RestoreTransactionsCubit>()
                          .restoreTransactions();
                      context
                          .read<TransactionsCubit>()
                          .loadRecentTransactions();
                    },
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          child: Text(
                            "Restore Transactions",
                            style: AppFonts.black18,
                            maxLines: 2,
                            // overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    tileColor: AppColors.white,

                    // trailing: Icon(Icons.edit, color: AppColors.grey),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: tilePadding,
                    ),
                  );
                },
              ),
              spacerLine(),
              BlocBuilder<BackupTransactionsCubit, BackupTransactionsState>(
                builder: (context, state) {
                  if (state is BackupTransactionsLoading) {
                    return ListTile(
                      onTap: () {},
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            child: Text(
                              "Backing Up Transactions...",
                              style: AppFonts.black18,
                              maxLines: 2,
                              // overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      trailing: LoadingAnimationWidget.threeArchedCircle(
                        color: Colors.black,
                        size: 18.sp,
                      ),
                      tileColor: AppColors.white,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: tilePadding,
                      ),
                    );
                  }
                  return ListTile(
                    onTap: () {
                      context
                          .read<BackupTransactionsCubit>()
                          .backupTransactions();
                    },
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          child: Text(
                            "Backup Now",
                            style: AppFonts.black18,
                            maxLines: 2,
                            // overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    tileColor: AppColors.white,

                    // trailing: Icon(Icons.edit, color: AppColors.grey),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: tilePadding,
                    ),
                  );
                },
              ),
              spacerLine(),
              spacerLine(),

              ListTile(
                onTap: () async {
                  await context.read<AppModeCubit>().setAppModeToBusiness();
                },
                // title: Text("Email"),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Switch to Business Mode",
                      style: AppFonts.black18,
                      maxLines: 2,
                      // overflow: TextOverflow.ellipsis,
                    ),
                    Icon(Icons.swap_horiz, color: Colors.blue),
                  ],
                ),
                tileColor: AppColors.white,

                // trailing: Icon(Icons.edit, color: AppColors.grey),
                contentPadding: EdgeInsets.symmetric(horizontal: tilePadding),
              ),
              spacerLine(),
              // SizedBox(height: 10.h),
              // Text("Account Created on 1/9/2026", style: AppFonts.grey14),

              //sign out btn
              SizedBox(height: 20.h),
              TextButton(
                onPressed: () async {
                  await showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (context) {
                      return AlertDialog(
                        actionsPadding: EdgeInsets.symmetric(
                          horizontal: 15.w,
                          vertical: 10.w,
                        ),
                        title: Text("Sign Out", style: AppFonts.black18),
                        content: Text(
                          "Are you sure you want to sign out?",
                          style: AppFonts.grey16,
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("Cancel", style: AppFonts.grey16),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);

                              context
                                  .read<AddTransactionCubit>()
                                  .transactionRepository
                                  .clearTransactions();
                              sharedPrefs.remove(SharedPrefCons.token);
                              DioFactory.removeTokenFromHeaderAfterLogout();
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SigninScreen(),
                                ),
                                (route) {
                                  return false;
                                },
                              );
                            },
                            child: Text("Sign Out", style: AppFonts.red16),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Sign Out", style: AppFonts.red18),
                    SizedBox(width: 15.w),
                    Icon(Icons.logout, color: AppColors.red, size: 22.sp),
                  ],
                ),
              ),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }
}
