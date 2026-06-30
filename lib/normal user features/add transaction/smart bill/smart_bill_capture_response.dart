import 'package:freezed_annotation/freezed_annotation.dart';
part 'smart_bill_capture_response.g.dart';
@JsonSerializable()
class SmartBillCaptureResponse {
  bool? success;
  @JsonKey(name: "extracted_data")
  ExtractedDate? extractedData;
  SmartBillCaptureResponse({this.success, this.extractedData});
  factory SmartBillCaptureResponse.fromJson(Map<String, dynamic> json) => _$SmartBillCaptureResponseFromJson(json);

}

@JsonSerializable()
class ExtractedDate{
  String? date;
  int? date_epoch_ms;
  double? total;
  String? category;
  ExtractedDate({this.date, this.total, this.category,this.date_epoch_ms});
  factory ExtractedDate.fromJson(Map<String, dynamic> json) => _$ExtractedDateFromJson(json);
}
