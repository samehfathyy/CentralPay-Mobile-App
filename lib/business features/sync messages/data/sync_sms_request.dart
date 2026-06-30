import 'package:freezed_annotation/freezed_annotation.dart';
part 'sync_sms_request.g.dart';

@JsonSerializable()
class SyncSmsRequest {
  @JsonKey(name: "Lastsyncdate")
  final String lastSyncDate;
  @JsonKey(name: "Devicename")
  final String deviceName;
  @JsonKey(name: "Messages")
  final List<SmsM> messages;

  SyncSmsRequest({
    required this.lastSyncDate,
    required this.deviceName,
    required this.messages,
  });

  Map<String, dynamic> toJson() => _$SyncSmsRequestToJson(this);
}

@JsonSerializable()
class SmsM {
  @JsonKey(name: "Sender")
  final String sender;
  @JsonKey(name: "MessageBody")
  final String body;
  @JsonKey(name: "Date")
  final String date;

  SmsM({required this.sender, required this.body, required this.date});

  Map<String, dynamic> toJson() => _$SmsMToJson(this);
}
