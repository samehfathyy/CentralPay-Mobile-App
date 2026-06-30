part of 'app_mode_cubit.dart';

@immutable
sealed class AppModeState {}

final class AppModeInitial extends AppModeState {}
final class AppModeNormalUser extends AppModeState {}
final class AppModeSwitchingToNormalUser extends AppModeState {}
final class AppModeBusiness extends AppModeState {}
final class AppModeSwitchingToBusiness extends AppModeState {}
