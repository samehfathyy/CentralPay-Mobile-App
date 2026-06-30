import 'package:bloc/bloc.dart';
import 'package:budgeta/core/network/api_result.dart';
import 'package:budgeta/features/Authentication/sign%20up/data/models/signup_request.dart';
import 'package:budgeta/features/Authentication/auth_repo.dart';
import 'package:meta/meta.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit(this._authRepo) : super(SignUpInitial());
  final AuthRepo _authRepo;
  // late String _email;

  Future<void> signup(SignupRequest signupRequest) async {
        emit(SigningUp());
    final response = await _authRepo.signup(signupRequest);
    response.when(
      success: (data) {
        // _email = data.data?.userData?.email ?? "";
        emit(SignUpSuccess());
      },
      failure: (message) {
        print(message);
        emit(SignUpError(msg: message));
      },
    );
    // emit(SigningUp());
    // await Future.delayed(Duration(seconds: 3));
    // final token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2OTlmNWVkZjU0ODFhODNkZGE5Y2ZlMGYiLCJyb2xlIjoiYnVzaW5lc3MiLCJlbWFpbCI6InNhbWVoZmF0aHkwODA4MDhAZ21haWwuY29tIiwibmFtZSI6InNhbWVoIiwidmVyaWZpZWQiOnRydWUsImlhdCI6MTc3MjEyMDEzNywiZXhwIjoxNzcyNzI0OTM3fQ.M-stbVEbhHYykv18QBZx9qyjZMALDbKZ7O4DBFZcivQ";
    // DioFactory.setTokenIntoHeaderAfterLogin(token);
    // final res = await _authRepo.getUserData();
    // res.when(
    //   success: (data) {
    //     print(data.data?.email ?? "");
    //   },
    //   faliure: (data) {
    //     print(data);
    //   },
    // );
    // emit(SignUpSuccess());
    // emit(SignUpError(msg: "An error occurred while signing up. Please try again later."));
  }
}
