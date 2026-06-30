import 'package:budgeta/core/network/api_result.dart';
import 'package:budgeta/core/network/api_service.dart';
import 'package:budgeta/features/Authentication/sign%20in/data/signin_request.dart';
import 'package:budgeta/features/Authentication/sign%20in/data/signin_response.dart';
import 'package:budgeta/features/Authentication/sign%20up/data/models/signup_request.dart';
import 'package:budgeta/features/Authentication/sign%20up/data/models/signup_response.dart';
import 'package:budgeta/features/Authentication/user%20data/user_data_response.dart';
import 'package:budgeta/features/Authentication/verify/data/models/verify_request.dart';
import 'package:budgeta/features/Authentication/verify/data/models/verify_response.dart';

class AuthRepo {
  final ApiService apiService;
  AuthRepo({required this.apiService});
  SignupResponse? signupResponse;
  UserDataResponse? userDataResponse;

  String getEmail() {
    return signupResponse?.data?.userData?.email ?? "";
  }

  Future<ApiResult<SignupResponse>> signup(SignupRequest request) async {
    try {
      final response = await apiService.signup(request);
      signupResponse = response;
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(e.toString());
    }
  }

  Future<ApiResult<SigninResponse>> signin(SignInRequest request) async {
    String? msg;
    try {
      final response = await apiService.signin(request);
      msg = response.message;
      return ApiResult.success(response);
    } catch (e) {
      // print("error catch");
      print('TYPE: ${e.toString()}');
      // print('MESSAGE: ${e.message}');
      // print('ERROR: ${e.error}');
      // print('RESPONSE: ${e.response}');
      return ApiResult.failure(msg ?? "Unexpected error occurred");
    }
  }

  Future<ApiResult<UserDataResponse>> getUserData() async {
    try {
      final response = await apiService.getUserData();
      userDataResponse = response;
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(e.toString());
    }
  }

  Future<ApiResult<VerifyResponse>> verify(String code) async {
    VerifyRequest request = VerifyRequest(
      email: signupResponse?.data?.userData?.email ?? "",
      otp: code,
    );

    try {
      final response = await apiService.verify(request);
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(e.toString());
    }
  }
}
