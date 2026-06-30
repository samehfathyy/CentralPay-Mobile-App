part of 'otp_verify_cubit.dart';

@immutable
sealed class OtpVerifyState {}

final class OtpVerifyInitial extends OtpVerifyState {
  final String email;

  OtpVerifyInitial({required this.email});
}

final class OtpVerifying extends OtpVerifyState {}

final class OtpVerifySuccess extends OtpVerifyState {}

final class OtpVerifyFailure extends OtpVerifyState {
  final String msg;

  OtpVerifyFailure({required this.msg});

}
