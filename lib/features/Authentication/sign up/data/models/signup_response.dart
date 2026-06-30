import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';


part 'signup_response.g.dart';

@JsonSerializable()
class SignupResponse {
  String? message;
  String? status;
  Data? data;

  SignupResponse({this.message, this.status, this.data});

  factory SignupResponse.fromJson(Map<String, dynamic> json) =>
      _$SignupResponseFromJson(json);

}

@JsonSerializable()
class Data {
  @JsonKey(name: 'user')
  User? userData;
  String? qrCode;
  Data({this.userData, this.qrCode});
  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
}

@JsonSerializable()
class User {
  String? id;
  String? name;
  String? email;
  String? role;
  bool? verified;

  User({this.id, this.name, this.email, this.role, this.verified});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
