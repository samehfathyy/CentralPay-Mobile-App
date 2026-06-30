import 'package:freezed_annotation/freezed_annotation.dart';

part 'signup_request.g.dart';

@JsonSerializable()
class SignupRequest {
  String name;
  String email;
  String password;

  SignupRequest({required this.name, required this.email, required this.password});

  Map<String, dynamic> toJson() => _$SignupRequestToJson(this);
}