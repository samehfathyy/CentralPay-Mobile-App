
import 'package:freezed_annotation/freezed_annotation.dart';

part 'verify_response.g.dart';

@JsonSerializable()
class VerifyResponse {
  String? message;
  String? status;
  Data? data;

  VerifyResponse({this.message, this.status, this.data});

  factory VerifyResponse.fromJson(Map<String, dynamic> json) =>
      _$VerifyResponseFromJson(json);

}


@JsonSerializable()
class Data {
  String? token;
  // JsonKey(name: "user")
  User? user;
  Data({ this.token, this.user});
  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
}

@JsonSerializable()
class User {
  String? id;
  String? name;
  String? email;
  String? role;
  bool? verified;
  User({  this.id, this.name, this.email, this.role, this.verified});
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}