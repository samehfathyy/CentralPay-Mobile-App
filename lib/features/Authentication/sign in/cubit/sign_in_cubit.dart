import 'package:bloc/bloc.dart';
import 'package:budgeta/core/constansts/shared_pref_cons.dart';
import 'package:budgeta/core/network/api_result.dart';
import 'package:budgeta/core/network/dio_factory.dart';
import 'package:budgeta/features/Authentication/auth_repo.dart';
import 'package:budgeta/features/Authentication/sign%20in/data/signin_request.dart';
import 'package:budgeta/main.dart';
import 'package:meta/meta.dart';

part 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit(this._authRepo) : super(SignInInitial());
  final AuthRepo _authRepo;

  Future<void> signIn(SignInRequest signinrequest) async {
    emit(SignInLoading());
    final response = await _authRepo.signin(signinrequest);
    response.when(
      success: (data) async {
        final token = data.data?.userData?.token ?? "";
        if (token == "") {
          emit(
            SignInFailure("Unexpected error occurred. Please try again later."),
          );
          return;
        }
        await sharedPrefs.setString(SharedPrefCons.token, token);
        DioFactory.setTokenIntoHeaderAfterLogin(token);

        emit(SignInSuccess());
      },
      failure: (message) {
        emit(SignInFailure(message));
      },
    );
  }
}
