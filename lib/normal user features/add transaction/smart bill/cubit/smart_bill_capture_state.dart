part of 'smart_bill_capture_cubit.dart';

@immutable
sealed class SmartBillCaptureState {}

final class SmartBillCaptureInitial extends SmartBillCaptureState {}

final class SmartBillCaptureLoading extends SmartBillCaptureState {
  final File? imageFile;
  SmartBillCaptureLoading({this.imageFile});
}

final class SmartBillCaptureFaliure extends SmartBillCaptureState {
  final String msg;

  SmartBillCaptureFaliure({required this.msg});
}

final class SmartBillCaptureSuccess extends SmartBillCaptureState {}
