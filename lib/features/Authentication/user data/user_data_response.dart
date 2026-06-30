import 'package:freezed_annotation/freezed_annotation.dart';
part 'user_data_response.g.dart';

@JsonSerializable()
class UserDataResponse {
  final String? status;
  final String? message;
  final Data? data;

  UserDataResponse({

    this.status,
     this.message,
     this.data,
  });

  factory UserDataResponse.fromJson(Map<String, dynamic> json) => _$UserDataResponseFromJson(json);
}

@JsonSerializable()
class  Data {
  String? email;
  String? name;
  Data({
     this.email,
     this.name,
  });
  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
}