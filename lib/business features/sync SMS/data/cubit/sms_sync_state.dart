part of 'sms_sync_cubit.dart';

@immutable
sealed class SmsSyncState {}

final class SmsSyncInitial extends SmsSyncState {}

final class SmsSyncUploading extends SmsSyncState {}

final class SmsSyncSuccess extends SmsSyncState {}

final class SmsSyncError extends SmsSyncState {
  final String message;
  final int caseCode;
  SmsSyncError(this.message, this.caseCode);
}

class SyncProblemsCases {
  static int noMessagesFound = 1;
  static int noProviderSelectedYet = 2;
  static int smsAccessDenied = 3;
  static int apiError = 4;
}
