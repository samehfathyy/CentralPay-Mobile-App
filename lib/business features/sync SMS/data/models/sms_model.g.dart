// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sms_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SmsModel _$SmsModelFromJson(Map<String, dynamic> json) => SmsModel(
  sender: json['sender'] as String,
  body: json['body'] as String,
  epochDate: (json['epochDate'] as num).toInt(),
);

Map<String, dynamic> _$SmsModelToJson(SmsModel instance) => <String, dynamic>{
  'sender': instance.sender,
  'body': instance.body,
  'epochDate': instance.epochDate,
};
