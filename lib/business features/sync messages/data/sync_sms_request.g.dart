// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_sms_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************



Map<String, dynamic> _$SyncSmsRequestToJson(SyncSmsRequest instance) =>
    <String, dynamic>{
      'Lastsyncdate': instance.lastSyncDate,
      'Devicename': instance.deviceName,
      'Messages': instance.messages,
    };

SmsM _$SmsMFromJson(Map<String, dynamic> json) => SmsM(
  sender: json['Sender'] as String,
  body: json['MessageBody'] as String,
  date: json['Date'] as String,
);

Map<String, dynamic> _$SmsMToJson(SmsM instance) => <String, dynamic>{
  'Sender': instance.sender,
  'MessageBody': instance.body,
  'Date': instance.date,
};
