part of 'select_sms_provider_cubit.dart';

@immutable
sealed class SelectSmsProviderState {}

final class SelectSmsProviderInitial extends SelectSmsProviderState {}

final class SelectSmsProviderLoading extends SelectSmsProviderState {}

final class SelectSmsProviderLoadded extends SelectSmsProviderState {
  final List<dynamic> selected;
  final List<dynamic> notSelected;

  SelectSmsProviderLoadded( {required this.notSelected,required this.selected});
}

final class SelectSmsProviderError extends SelectSmsProviderState {
  final String message;

  SelectSmsProviderError({required this.message});
}

final class SelectSmsProviderEmpty extends SelectSmsProviderState {}
