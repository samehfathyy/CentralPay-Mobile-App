


import 'package:freezed_annotation/freezed_annotation.dart';
part 'backup__response.g.dart';
@JsonSerializable()
class BackupResponse {
  String status;
  String message;
  BackupResponse({required this.status, required this.message});
  factory BackupResponse.fromJson(Map<String, dynamic> json) =>
      _$BackupResponseFromJson(json);
}
