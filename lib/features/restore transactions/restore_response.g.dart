// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restore_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RestoreResponse _$RestoreResponseFromJson(Map<String, dynamic> json) =>
    RestoreResponse(
      status: json['status'] as String,
      message: json['message'] as String,
      data: RestoreData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RestoreResponseToJson(RestoreResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };

RestoreData _$RestoreDataFromJson(Map<String, dynamic> json) => RestoreData(
  count: (json['count'] as num).toInt(),
  trans: (json['trans'] as List<dynamic>)
      .map((e) => RestoreTransaction.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$RestoreDataToJson(RestoreData instance) =>
    <String, dynamic>{'count': instance.count, 'trans': instance.trans};

RestoreTransaction _$RestoreTransactionFromJson(Map<String, dynamic> json) =>
    RestoreTransaction(
      amount: (json['amount'] as num).toDouble(),
      expense: json['expense'] as bool,
      category: json['category'] as String,
      date: DateTime.parse(json['date'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$RestoreTransactionToJson(RestoreTransaction instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'expense': instance.expense,
      'category': instance.category,
      'date': instance.date.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
    };
