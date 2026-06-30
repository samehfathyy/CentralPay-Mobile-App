import 'package:freezed_annotation/freezed_annotation.dart';
part 'sync_sms_response.g.dart';

@JsonSerializable()
class SyncSmsResponse {
  String? Status;
  SyncSmsResponse({this.Status});
  factory SyncSmsResponse.fromJson(Map<String, dynamic> json) => _$SyncSmsResponseFromJson(json);
}
