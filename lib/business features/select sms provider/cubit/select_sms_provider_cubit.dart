import 'package:bloc/bloc.dart';
import 'package:budgeta/business%20features/select%20sms%20provider/data/sms_providers_repo.dart';
import 'package:meta/meta.dart';
import 'package:permission_handler/permission_handler.dart';

part 'select_sms_provider_state.dart';

class SelectSmsProviderCubit extends Cubit<SelectSmsProviderState> {
  SelectSmsProviderCubit(this._providersRepo)
    : super(SelectSmsProviderInitial());
  final SmsProvidersRepo _providersRepo;
  Future<void> init() async {
    emit(SelectSmsProviderLoading());
    var status = await Permission.sms.status;
    if (status.isGranted) {
      print("sms granted");
      await _providersRepo.loadSelectedAndNonSelectedProviders();
      _emitLoadedState();
      return;
    }
    print("sms not granted");
    status = await Permission.sms.request();
    if (status.isGranted) {
      init();
    } else {
      emit(SelectSmsProviderError(message: "SMS permission is not granted"));
    }
  }

  void swapSelection(dynamic provider) {
    _providersRepo.swap(provider);
    _emitLoadedState();
  }

  void _emitLoadedState() {
    emit(
      SelectSmsProviderLoadded(
        selected: _providersRepo.getSelected(),
        notSelected: _providersRepo.getNotSelected(),
      ),
    );
  }

  Future<void> saveChanges() async {
    await _providersRepo.saveSelectingProcess();
  }

}
