
import 'package:freezed_annotation/freezed_annotation.dart';
part 'signin_request.g.dart';
@JsonSerializable()
class SignInRequest {
  final String email;
  final String password;
  SignInRequest({
    required this.email,
    required this.password,
  });
  
  // factory LoginRequest.fromJson(Map<String, dynamic> json) => _$LoginRequestFromJson(json);
  Map<String, dynamic> toJson() => _$SignInRequestToJson(this);
}