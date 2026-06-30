import 'package:budgeta/business%20features/business_home_screen.dart';
import 'package:budgeta/business%20features/select%20sms%20provider/cubit/select_sms_provider_cubit.dart';
import 'package:budgeta/business%20features/sync%20SMS/data/cubit/sms_sync_cubit.dart';
import 'package:budgeta/core/constansts/shared_pref_cons.dart';
import 'package:budgeta/core/dependency_injection.dart';
import 'package:budgeta/core/theming/App_Colors.dart';
import 'package:budgeta/features/Authentication/sign%20in/cubit/sign_in_cubit.dart';
import 'package:budgeta/features/Authentication/sign%20up/cubit/sign_up_cubit.dart';
import 'package:budgeta/features/Authentication/token%20validator/cubit/token_validator_cubit.dart';
import 'package:budgeta/features/Authentication/token%20validator/token_validator_screen.dart';
import 'package:budgeta/features/Authentication/verify/cubit/otp_verify_cubit.dart';
import 'package:budgeta/features/backup%20transactions/cubit/backup_transactions_cubit.dart';
import 'package:budgeta/features/restore%20transactions/cubit/cubit/restore_transactions_cubit.dart';
import 'package:budgeta/features/switch%20app%20mode/cubit/app_mode_cubit.dart';
import 'package:budgeta/features/welcome/welcome_screen.dart';
import 'package:budgeta/normal%20user%20features/add%20transaction/cubit/cubit/add_transaction_cubit.dart';
import 'package:budgeta/normal%20user%20features/add%20transaction/data/transaction_repository.dart';
import 'package:budgeta/normal%20user%20features/add%20transaction/smart%20bill/cubit/smart_bill_capture_cubit.dart';
import 'package:budgeta/normal%20user%20features/all%20transactions/cubit/monthly_transacrions_cubit.dart';
import 'package:budgeta/normal%20user%20features/budget%20limit/cubit/budget_limit_cubit.dart';
import 'package:budgeta/normal%20user%20features/show%20transactions/cubit/transactions_cubit.dart';
import 'package:budgeta/normal%20user%20features/statistics/cubit/statistics_cubit.dart';
import 'package:budgeta/user_start_app_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences sharedPrefs;
late bool appModeisBusiness;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPrefs = await SharedPreferences.getInstance();
  await setupDependencies();
  // TransactionRepository transactionRepository = getIt<TransactionRepository>();
  // final n = await transactionRepository.getRecentTransactions(
  //   DateTime.now(),
  //   DateTime.now().add(Duration(days: 1)),
  // );
  // print("trans count: ${n.length}");
  bool ft = sharedPrefs.getBool(SharedPrefCons.firstLaunch) ?? true;
  appModeisBusiness =
      sharedPrefs.getBool(SharedPrefCons.appModeisBusiness) ?? false;

  if (ft) {
    await sharedPrefs.setBool(SharedPrefCons.firstLaunch, false);
    await getIt<TransactionRepository>().addInitialCategories();
  }
  runApp( MyApp(firstLaunch: ft,));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.firstLaunch});
  final bool firstLaunch;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        //Auth
        BlocProvider<SignUpCubit>(create: (context) => getIt<SignUpCubit>()),
        BlocProvider<OtpVerifyCubit>(
          create: (context) => getIt<OtpVerifyCubit>(),
        ),
        BlocProvider<TokenValidatorCubit>(
          create: (context) =>
              getIt<TokenValidatorCubit>()..validateTokenAndCheckInternet(),
        ),
        BlocProvider<SignInCubit>(
          create: (context) => getIt<SignInCubit>(),
        ),
        BlocProvider<AppModeCubit>(
          create: (context) => getIt<AppModeCubit>(),
        ),

        //normal user
        BlocProvider<AddTransactionCubit>(
          create: (context) => getIt<AddTransactionCubit>(),
        ),
        BlocProvider<TransactionsCubit>(
          create: (context) =>
              getIt<TransactionsCubit>(),
        ),
        BlocProvider<StatisticsCubit>(
          create: (context) => getIt<StatisticsCubit>(),
        ),
        BlocProvider<MonthlyTransacrionsCubit>(
          create: (context) => getIt<MonthlyTransacrionsCubit>(),
        ),
        BlocProvider<SmartBillCaptureCubit>(
          create: (context) => getIt<SmartBillCaptureCubit>(),
        ),
        BlocProvider<RestoreTransactionsCubit>(
          create: (context) => getIt<RestoreTransactionsCubit>(),
        ),
        BlocProvider<RestoreTransactionsCubit>(
          create: (context) => getIt<RestoreTransactionsCubit>(),
        ),
        BlocProvider<BackupTransactionsCubit>(
          create: (context) => getIt<BackupTransactionsCubit>(),
        ),
        BlocProvider<BudgetLimitCubit>(
          create: (context) => getIt<BudgetLimitCubit>(),
        ),

        //business
        BlocProvider<SelectSmsProviderCubit>(
          create: (context) => getIt<SelectSmsProviderCubit>(),
        ),
        BlocProvider<SmsSyncCubit>(create: (context) => getIt<SmsSyncCubit>()),
      ],
      child: ScreenUtilInit(
        // minTextAdapt: true,
        // splitScreenMode: true,
        designSize: Size(375, 812),
        builder: (context, child) {
          return MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              fontFamily: 'Switzer',
              scaffoldBackgroundColor: AppColors.background,
            ),

            debugShowCheckedModeBanner: false,
            // home:WelcomeScreen(),
            home:widget.firstLaunch?WelcomeScreen() :TokenValidatorScreen(),
          );
        },
      ),
    );
  }
}

class NormalUserApp extends StatelessWidget {
  const NormalUserApp({super.key});

  @override
  Widget build(BuildContext context) {
    return UserStartAppScreen();
  }
}

class BusinessApp extends StatelessWidget {
  const BusinessApp({super.key});

  @override
  Widget build(BuildContext context) {
    // return const BusinessHomeScreen();
    return BusinessHomeScreen();
  }
}

// class NormalUserApp extends StatelessWidget {
//   const NormalUserApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         // BlocProvider<AddTransactionCubit>(
//         //   create: (context) => getIt<AddTransactionCubit>(),
//         // ),
//         BlocProvider<TransactionsCubit>(
//           create: (context) =>
//               getIt<TransactionsCubit>()..loadRecentTransactions(),
//         ),
//         BlocProvider<StatisticsCubit>(
//           create: (context) => getIt<StatisticsCubit>(),
//         ),
//         BlocProvider<MonthlyTransacrionsCubit>(
//           create: (context) => getIt<MonthlyTransacrionsCubit>(),
//         ),
//       ],
//       child: UserStartAppScreen(),
//     );
//   }
// }

// class BusinessApp extends StatelessWidget {
//   const BusinessApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // return const BusinessHomeScreen();
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider<SelectSmsProviderCubit>(
//           create: (context) => getIt<SelectSmsProviderCubit>(),
//         ),
//       ],
//       child: BusinessHomeScreen(),
//     );
//   }
// }

// class StartApp extends StatelessWidget {
//   const StartApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [BlocProvider(create: (context) => LightModeCubit())],
//       child: BlocBuilder<LightModeCubit, LightModeState>(
//         builder: (context, state) {

//           if (state is LightModeInitial) return HomeScreen();
//           return SizedBox();
//         },
//       ),
//     );
//   }
// }
