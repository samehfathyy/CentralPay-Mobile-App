import 'package:freezed_annotation/freezed_annotation.dart';
part 'sms_model.g.dart';

@JsonSerializable()
class SmsModel {
  String sender;
  String body;
  int epochDate;

  SmsModel({required this.sender, required this.body, required this.epochDate});

  Map<String, dynamic> toJson() => _$SmsModelToJson(this);

  factory SmsModel.fromJson(Map<String, dynamic> json) =>
      _$SmsModelFromJson(json);

  // Map<String, dynamic> toMap() {
  //   return {
  //     'sender': sender,
  //     'message': message,
  //     'epochDate': epochDate,
  //   };
  // }

  // factory SmsModel.fromMap(Map<String, dynamic> map) {
  //   return SmsModel(
  //     sender: map['sender'],
  //     message: map['message'],
  //     epochDate: map['epochDate'],
  //   );
  // }
}
