
import 'package:freezed_annotation/freezed_annotation.dart';

part 'backup_request_body.g.dart';

@JsonSerializable()
class BackupRequestBody {
  List<BackupTransaction> transactions;
  BackupRequestBody({required this.transactions});
  Map<String, dynamic> toJson() => _$BackupRequestBodyToJson(this);
}

@JsonSerializable()
class BackupTransaction {
  String category;
  double amount;
  String date;
  bool expense;

  BackupTransaction({
    required this.category,
    required this.amount,
    required this.date,
    required this.expense,
  });
  Map<String, dynamic> toJson() => _$BackupTransactionToJson(this);
}