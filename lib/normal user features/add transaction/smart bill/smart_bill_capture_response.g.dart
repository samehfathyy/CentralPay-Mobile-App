// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'smart_bill_capture_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SmartBillCaptureResponse _$SmartBillCaptureResponseFromJson(
  Map<String, dynamic> json,
) => SmartBillCaptureResponse(
  success: json['success'] as bool?,
  extractedData: json['extracted_data'] == null
      ? null
      : ExtractedDate.fromJson(json['extracted_data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$SmartBillCaptureResponseToJson(
  SmartBillCaptureResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'extracted_data': instance.extractedData,
};

ExtractedDate _$ExtractedDateFromJson(Map<String, dynamic> json) =>
    ExtractedDate(
      date: json['date'] as String?,
      total: (json['total'] as num?)?.toDouble(),
      category: json['category'] as String?,
      date_epoch_ms: (json['date_epoch_ms'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ExtractedDateToJson(ExtractedDate instance) =>
    <String, dynamic>{
      'date': instance.date,
      'date_epoch_ms': instance.date_epoch_ms,
      'total': instance.total,
      'category': instance.category,
    };
