

import 'package:freezed_annotation/freezed_annotation.dart';
part 'signin_response.g.dart';
@JsonSerializable()
class SigninResponse {
  String? message;
  String? status;
  Data? data;

  SigninResponse({this.message, this.status, this.data});

  factory SigninResponse.fromJson(Map<String, dynamic> json) =>
      _$SigninResponseFromJson(json);

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
  String? token;

  User({this.id, this.name, this.email, this.role, this.verified, this.token});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
