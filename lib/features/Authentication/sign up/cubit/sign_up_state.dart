part of 'sign_up_cubit.dart';

@immutable
sealed class SignUpState {}

final class SignUpInitial extends SignUpState {}
final class SigningUp extends SignUpState {}
final class SignUpError extends SignUpState {
  final String msg;

  SignUpError({required this.msg});
}


final class SignUpSuccess extends SignUpState {}
