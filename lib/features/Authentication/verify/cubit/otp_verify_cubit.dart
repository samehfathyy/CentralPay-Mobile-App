
import 'package:bloc/bloc.dart';
import 'package:budgeta/core/constansts/shared_pref_cons.dart';
import 'package:budgeta/core/network/api_result.dart';
import 'package:budgeta/core/network/dio_factory.dart';
import 'package:budgeta/features/Authentication/auth_repo.dart';
import 'package:budgeta/main.dart';
import 'package:meta/meta.dart';

part 'otp_verify_state.dart';

class OtpVerifyCubit extends Cubit<OtpVerifyState> {
  OtpVerifyCubit(this._authRepo)
    : super(OtpVerifyInitial(email: _authRepo.getEmail()));

  final AuthRepo _authRepo;

  Future<void> verify(String otp) async {
    emit(OtpVerifying());
    // VerifyRequest verifyRequest = VerifyRequest(email: _email, otp: otp);
    final response = await _authRepo.verify(otp);
    response.when(
      success: (data) async {
        final token = data.data?.token ?? "";
        if (token.isNotEmpty) {
          print("token$token");
          await sharedPrefs.setString(SharedPrefCons.token, token);
          DioFactory.setTokenIntoHeaderAfterLogin(token);
          emit(OtpVerifySuccess());
          return;
        }
        emit(
          OtpVerifyFailure(
            msg: "unexpected error occurred. Please try again later.",
          ),
        );
      },
      failure: (message) {
        emit(OtpVerifyFailure(msg: message));
      },
    );
  }

  String getEmail() {
    return _authRepo.getEmail();
  }
}
