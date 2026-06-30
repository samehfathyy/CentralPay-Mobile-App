part of 'token_validator_cubit.dart';

@immutable
sealed class TokenValidatorState {}

final class TokenValidatorInitial extends TokenValidatorState {}
final class TokenValidatorLoading extends TokenValidatorState {}
final class NoInternetConncetion extends TokenValidatorState {}
final class TokenNotValid extends TokenValidatorState {}
final class TokenValid extends TokenValidatorState {}
