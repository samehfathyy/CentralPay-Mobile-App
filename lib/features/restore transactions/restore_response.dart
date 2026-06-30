


import 'package:freezed_annotation/freezed_annotation.dart';
part 'restore_response.g.dart';
@JsonSerializable()
class RestoreResponse {
  final String status;
  final String message;
  final RestoreData data;

  RestoreResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory RestoreResponse.fromJson(Map<String, dynamic> json) =>
      _$RestoreResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RestoreResponseToJson(this);
}

@JsonSerializable()
class RestoreData {
  final int count;
  final List<RestoreTransaction> trans;

  RestoreData({
    required this.count,
    required this.trans,
  });

  factory RestoreData.fromJson(Map<String, dynamic> json) =>
      _$RestoreDataFromJson(json);

  Map<String, dynamic> toJson() => _$RestoreDataToJson(this);
}

@JsonSerializable()
class RestoreTransaction {
  final double amount;
  final bool expense;
  final String category;
  final DateTime date;
  final DateTime createdAt;

  RestoreTransaction({
    required this.amount,
    required this.expense,
    required this.category,
    required this.date,
    required this.createdAt,
  });

  factory RestoreTransaction.fromJson(Map<String, dynamic> json) =>
      _$RestoreTransactionFromJson(json);

  Map<String, dynamic> toJson() => _$RestoreTransactionToJson(this);
}