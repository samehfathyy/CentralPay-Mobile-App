// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'backup__response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BackupResponse _$BackupResponseFromJson(Map<String, dynamic> json) =>
    BackupResponse(
      status: json['status'] as String,
      message: json['message'] as String,
    );

Map<String, dynamic> _$BackupResponseToJson(BackupResponse instance) =>
    <String, dynamic>{'status': instance.status, 'message': instance.message};
