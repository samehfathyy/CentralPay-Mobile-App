// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'backup_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************


Map<String, dynamic> _$BackupRequestBodyToJson(BackupRequestBody instance) =>
    <String, dynamic>{'transactions': instance.transactions};

BackupTransaction _$BackupTransactionFromJson(Map<String, dynamic> json) =>
    BackupTransaction(
      category: json['category'] as String,
      amount: (json['amount'] as num).toDouble(),
      date: json['date'] as String,
      expense: json['expense'] as bool,
    );

Map<String, dynamic> _$BackupTransactionToJson(BackupTransaction instance) =>
    <String, dynamic>{
      'category': instance.category,
      'amount': instance.amount,
      'date': instance.date,
      'expense': instance.expense,
    };
