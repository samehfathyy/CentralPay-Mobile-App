import 'package:budgeta/business%20features/sync%20messages/data/sync_sms_request.dart';
import 'package:budgeta/business%20features/sync%20messages/data/sync_sms_response.dart';
import 'package:budgeta/core/network/api_result.dart';
import 'package:budgeta/core/network/api_service.dart';

class SmsRepo {
  final ApiService _apiService;

  SmsRepo({required ApiService apiService}) : _apiService = apiService;
  Future<ApiResult<SyncSmsResponse>> sendMessages({
    required int lastSyncDate,
    required String deviceName,
    required List<SmsM> messages,
  }) async {
    try {
      final request = SyncSmsRequest(
        lastSyncDate: lastSyncDate.toString(),
        deviceName: deviceName,
        messages: messages,
      );
      final response = await _apiService.sendMessages(request);
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(e.toString());
    }
  }
}
