
import 'package:freezed_annotation/freezed_annotation.dart';

part 'verify_request.g.dart';

@JsonSerializable()
class VerifyRequest {
  String email;
  String otp;

  VerifyRequest({ required this.email, required this.otp});

  // factory SignupRequest.fromJson(Map<String, dynamic> json) =>
  //     _$SignupRequestFromJson(json);

  Map<String, dynamic> toJson() => _$VerifyRequestToJson(this);
  
}