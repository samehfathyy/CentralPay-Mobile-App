import 'dart:io';

import 'package:budgeta/business%20features/sync%20messages/data/sync_sms_request.dart';
import 'package:budgeta/business%20features/sync%20messages/data/sync_sms_response.dart';
import 'package:budgeta/features/Authentication/sign%20in/data/signin_request.dart';
import 'package:budgeta/features/Authentication/sign%20in/data/signin_response.dart';
import 'package:budgeta/features/Authentication/sign%20up/data/models/signup_request.dart';
import 'package:budgeta/features/Authentication/sign%20up/data/models/signup_response.dart';
import 'package:budgeta/features/Authentication/user%20data/user_data_response.dart';
import 'package:budgeta/features/Authentication/verify/data/models/verify_request.dart';
import 'package:budgeta/features/Authentication/verify/data/models/verify_response.dart';
import 'package:budgeta/features/backup%20transactions/backup__response.dart';
import 'package:budgeta/features/backup%20transactions/backup_request_body.dart';
import 'package:budgeta/features/restore%20transactions/restore_response.dart';
import 'package:budgeta/normal%20user%20features/add%20transaction/smart%20bill/smart_bill_capture_response.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: "https://centralpay-production.up.railway.app/")
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @POST("user/signup")
  Future<SignupResponse> signup(@Body() SignupRequest request);

  @POST("user/signin")
  Future<SigninResponse> signin(@Body() SignInRequest request);

  @POST("user/verify")
  Future<VerifyResponse> verify(@Body() VerifyRequest request);

  @GET("user/userData")
  Future<UserDataResponse> getUserData();

  @POST("message/parse")
  Future<SyncSmsResponse> sendMessages(@Body() SyncSmsRequest request);

  @POST("recepit/billCapture")
  @MultiPart()
  Future<SmartBillCaptureResponse> billImageToTransaction(@Part(name: "file") File file);

  @POST("transaction/app/addManually")
  Future<BackupResponse> backupTransactions(@Body() BackupRequestBody request);

  @GET("transaction/recents")
  Future<RestoreResponse> getRecentTransactions();
}
