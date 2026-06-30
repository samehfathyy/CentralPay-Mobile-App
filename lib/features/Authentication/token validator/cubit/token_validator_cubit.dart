import 'package:bloc/bloc.dart';
import 'package:budgeta/core/constansts/shared_pref_cons.dart';
import 'package:budgeta/core/network/api_result.dart';
import 'package:budgeta/features/Authentication/auth_repo.dart';
import 'package:budgeta/main.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

part 'token_validator_state.dart';

class TokenValidatorCubit extends Cubit<TokenValidatorState> {
  TokenValidatorCubit(this._dio, this._authRepo)
    : super(TokenValidatorInitial());
  final Dio _dio;
  final AuthRepo _authRepo;
  Future<void> validateTokenAndCheckInternet() async {
    emit(TokenValidatorLoading());
    try {
      final response = await _dio.get(
        'https://www.google.com',
        options: Options(
          receiveTimeout: const Duration(seconds: 5), // 5 seconds timeout
          sendTimeout: const Duration(seconds: 5),
        ),
      );
      if (response.statusCode == 200) {
        await checkToken();
      } else {}
    } catch (e) {
      emit(NoInternetConncetion());
    }
  }

  Future<void> checkToken() async {
    final token = sharedPrefs.getString(SharedPrefCons.token);
    if (token == null) {
      emit(TokenNotValid());
      return;
    }
    final response = await _authRepo.getUserData();
    response.when(
      success: (data) {
        emit(TokenValid());
      },
      failure: (message) {
        emit(TokenNotValid());
      },
    );
  }
}
