import 'package:budgeta/business%20features/select%20sms%20provider/cubit/select_sms_provider_cubit.dart';
import 'package:budgeta/business%20features/select%20sms%20provider/data/sms_providers_repo.dart';
import 'package:budgeta/business%20features/sync%20SMS/data/cubit/sms_sync_cubit.dart';
import 'package:budgeta/business%20features/sync%20messages/data/sms_repo.dart';
import 'package:budgeta/core/database/dbHelper.dart';
import 'package:budgeta/core/network/api_service.dart';
import 'package:budgeta/core/network/dio_factory.dart';
import 'package:budgeta/features/Authentication/sign%20in/cubit/sign_in_cubit.dart';
import 'package:budgeta/features/Authentication/sign%20up/cubit/sign_up_cubit.dart';
import 'package:budgeta/features/Authentication/auth_repo.dart';
import 'package:budgeta/features/Authentication/token%20validator/cubit/token_validator_cubit.dart';
import 'package:budgeta/features/Authentication/verify/cubit/otp_verify_cubit.dart';
import 'package:budgeta/features/backup%20transactions/cubit/backup_transactions_cubit.dart';
import 'package:budgeta/features/restore%20transactions/cubit/cubit/restore_transactions_cubit.dart';
import 'package:budgeta/features/switch%20app%20mode/cubit/app_mode_cubit.dart';
import 'package:budgeta/normal%20user%20features/add%20transaction/cubit/cubit/add_transaction_cubit.dart';
import 'package:budgeta/normal%20user%20features/add%20transaction/data/transaction_repository.dart';
import 'package:budgeta/normal%20user%20features/add%20transaction/smart%20bill/cubit/smart_bill_capture_cubit.dart';
import 'package:budgeta/normal%20user%20features/all%20transactions/cubit/monthly_transacrions_cubit.dart';
import 'package:budgeta/normal%20user%20features/budget%20limit/cubit/budget_limit_cubit.dart';
import 'package:budgeta/normal%20user%20features/show%20transactions/cubit/transactions_cubit.dart';
import 'package:budgeta/normal%20user%20features/statistics/cubit/statistics_cubit.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;
Future<void> setupDependencies() async {
  //dio and db
  DBHelper dbHelper = DBHelper.instance;
  Dio dio =await DioFactory.getDio();

  //api services
  getIt.registerLazySingleton<ApiService>(() => ApiService(dio));

  //repos
  getIt.registerLazySingleton<TransactionRepository>(
    () => TransactionRepository(dbHelper: dbHelper,apiService: getIt<ApiService>()),
  );
  getIt.registerLazySingleton<AuthRepo>(
    () => AuthRepo(apiService: getIt<ApiService>()),
  );
  //business repos
  getIt.registerLazySingleton<SmsProvidersRepo>(
    () => SmsProvidersRepo(dbHelper: dbHelper),
  );
  getIt.registerLazySingleton<SmsRepo>(
    () => SmsRepo(apiService: getIt<ApiService>()),
  );

  //cubits
  getIt.registerLazySingleton<AddTransactionCubit>(
    () => AddTransactionCubit(getIt<TransactionRepository>()),
  );
  getIt.registerLazySingleton<TransactionsCubit>(
    () => TransactionsCubit(getIt<TransactionRepository>()),
  );
  getIt.registerLazySingleton<StatisticsCubit>(
    () => StatisticsCubit(getIt<TransactionRepository>()),
  );
  getIt.registerLazySingleton<MonthlyTransacrionsCubit>(
    () => MonthlyTransacrionsCubit(getIt<TransactionRepository>()),
  );
  getIt.registerLazySingleton<SmartBillCaptureCubit>(
    () => SmartBillCaptureCubit(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<RestoreTransactionsCubit>(
    () => RestoreTransactionsCubit(transaction_repo: getIt<TransactionRepository>()),
  );
  getIt.registerLazySingleton<BackupTransactionsCubit>(
    () => BackupTransactionsCubit( getIt<TransactionRepository>()),
  );
  getIt.registerLazySingleton<BudgetLimitCubit>(
    () => BudgetLimitCubit( getIt<TransactionRepository>()),
  );
  //business cubits
  getIt.registerLazySingleton<SelectSmsProviderCubit>(
    () => SelectSmsProviderCubit(getIt<SmsProvidersRepo>()),
  );
  getIt.registerLazySingleton<SmsSyncCubit>(
    () => SmsSyncCubit(getIt<SmsProvidersRepo>(), getIt<SmsRepo>()),
  );
  //Auth cubits
  getIt.registerLazySingleton<SignUpCubit>(
    () => SignUpCubit(getIt<AuthRepo>()),
  );
  getIt.registerLazySingleton<OtpVerifyCubit>(
    () => OtpVerifyCubit(getIt<AuthRepo>()),
  );
  getIt.registerLazySingleton<TokenValidatorCubit>(
    () => TokenValidatorCubit(dio,getIt<AuthRepo>()),
  );
  getIt.registerLazySingleton<SignInCubit>(
    () => SignInCubit(getIt<AuthRepo>()),
  );
  getIt.registerLazySingleton<AppModeCubit>(
    () => AppModeCubit(),
  );
}
