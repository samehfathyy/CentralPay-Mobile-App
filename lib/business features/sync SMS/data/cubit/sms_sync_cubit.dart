import 'package:android_sms_reader/android_sms_reader.dart';
import 'package:bloc/bloc.dart';
import 'package:budgeta/business%20features/select%20sms%20provider/data/sms_providers_repo.dart';
import 'package:budgeta/business%20features/sync%20messages/data/sms_repo.dart';
import 'package:budgeta/business%20features/sync%20messages/data/sync_sms_request.dart';
import 'package:budgeta/core/constansts/shared_pref_cons.dart';
import 'package:budgeta/core/helpers/DateHelpers.dart';
import 'package:budgeta/core/network/api_result.dart';
import 'package:budgeta/main.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:meta/meta.dart';
import 'package:permission_handler/permission_handler.dart';

part 'sms_sync_state.dart';

class SmsSyncCubit extends Cubit<SmsSyncState> {
  SmsSyncCubit(this._smsProvidersRepo, this._smsRepo) : super(SmsSyncInitial());
  final SmsProvidersRepo _smsProvidersRepo;
  final SmsRepo _smsRepo;
  String lastSyncDate = "";
  String deviceName = "";

  Future<void> init() async {
    emit(SmsSyncInitial());
    int? lastSyncEpoch = await getLastSyncEpochDate();
    deviceName = await getDeviceName();
    lastSyncEpoch==null?lastSyncDate="Not synced yet":
    lastSyncDate = DateTime.fromMillisecondsSinceEpoch(
      lastSyncEpoch,
    ).toDateFormat_11jan2025();
    if (await checkSmsAccess()) {
      await _smsProvidersRepo.loadSelectedAndNonSelectedProviders();
    }
    print(lastSyncDate);
    print(deviceName);
    emit(SmsSyncInitial());
  }

  Future<String> getDeviceName() async {
    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;
    return "${androidInfo.brand} ${androidInfo.model}"; // This is ANDROID_ID
  }

  Future<bool> checkSmsAccess() async {
    var status = await Permission.sms.status;
    if (status.isGranted) {
      return true;
    }
    status = await Permission.sms.request();
    if (status.isGranted) {
      return true;
    }
    emit(
      SmsSyncError(
        "SMS permission is not granted",
        SyncProblemsCases.smsAccessDenied,
      ),
    );
    return false;
  }

  Future<bool> checkForMessages() async {
    bool noMessagesFound =
        await AndroidSMSReader.getMessageCount(AndroidSMSType.inbox) == 0;
    if (noMessagesFound) {
      emit(
        SmsSyncError(
          "you have no sms messages",
          SyncProblemsCases.noMessagesFound,
        ),
      );
      return false;
    }
    return true;
  }

  Future<int?> getLastSyncEpochDate() async {
    //if it is equal to null get it from website
    // return DateTime(2000).millisecondsSinceEpoch;
    int? lastSyncEpoch = sharedPrefs.getInt(
      SharedPrefCons.lastSyncDateEpoch,
    );
    // DateTime(2000).millisecondsSinceEpoch;
    return lastSyncEpoch;
  }
  Future<void> clearLastSyncEpochDate() async {
    await sharedPrefs.remove(SharedPrefCons.lastSyncDateEpoch);
        emit(SmsSyncInitial());

  }

  Future<void> setLastSyncEpochDate(int lastSyncEpoch) async {
    await sharedPrefs.setInt(SharedPrefCons.lastSyncDateEpoch, lastSyncEpoch);
        emit(SmsSyncInitial());

  }

  Future<void> Fetch() async {
    emit(SmsSyncUploading());
    // var status = await Permission.sms.status;
    // print(status);
    // if (!status.isGranted) {
    //   emit(
    //     SmsSyncError(
    //       "SMS permission is not granted",
    //       SyncProblemsCases.smsAccessDenied,
    //     ),
    //   );
    //   return;
    // }
    // await init();
    bool accessStatus = await checkSmsAccess();
    if (!accessStatus) return;
    bool messagesFound = await checkForMessages();
    if (!messagesFound) return;

    final List<String> selectedAdresses = _smsProvidersRepo
        .getSelected()
        .map((e) => e.name)
        .toList();

    if (selectedAdresses.isEmpty) {
      emit(
        SmsSyncError(
          "select your banks and mobile wallets first",
          SyncProblemsCases.noProviderSelectedYet,
        ),
      );
      return;
    }
    final chunkSize = 5000;
    int start = 0;
    int lastSyncEpoch = await getLastSyncEpochDate()??0;
    bool whileloop = true;
    int? last;
    while (whileloop) {
      final messages = await AndroidSMSReader.fetchMessages(
        type: AndroidSMSType.inbox,
        start: start,
        count: chunkSize,
      );

      if (messages.isEmpty) {
        break;
      }
      List<SmsM> smsList = [];
      for (var sms in messages) {
        if (sms.date < lastSyncEpoch) {
          whileloop = false;
          break;
        }
        if (selectedAdresses.contains(sms.address)) {
          smsList.add(
            SmsM(
              sender: sms.address,
              body: sms.body,
              date: sms.date.toString(),
            ),
          );
        }
      }

      if (smsList.isNotEmpty) {
        //send this list to api simulation
        last = DateTime.now().millisecondsSinceEpoch;
        // await setLastSyncEpochDate(last);
        final result = await _smsRepo.sendMessages(
          lastSyncDate: last,
          deviceName: deviceName,
          messages: smsList,
        );
        result.when(
          success: (data) {
            emit(SmsSyncSuccess());
          },
          failure: (message) {
            emit(
              SmsSyncError(
                "Failed to sync messages: $message",
                SyncProblemsCases.apiError,
              ),
            );
          },
        );

        // for (var sms in smsList) {
        //   print(sms.Sender);
        // }
        // await Future.delayed(Duration(seconds: 2));
        //update last sync and send it to backend
      }
      start += chunkSize;
    }
    if (last != null) {
      await setLastSyncEpochDate(last);
    }
    emit(SmsSyncInitial());
  }
}
