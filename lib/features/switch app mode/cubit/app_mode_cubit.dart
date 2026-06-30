
import 'package:bloc/bloc.dart';
import 'package:budgeta/core/constansts/shared_pref_cons.dart';
import 'package:budgeta/main.dart';
import 'package:meta/meta.dart';

part 'app_mode_state.dart';

class AppModeCubit extends Cubit<AppModeState> {
  AppModeCubit() : super(AppModeSwitchingToNormalUser());
  Future<void> setAppModeToBusiness() async {
    await sharedPrefs.setBool(SharedPrefCons.appModeisBusiness, true);
    switchAppMode();
  }

  Future<void> setAppModeToNormal() async {
    await sharedPrefs.setBool(SharedPrefCons.appModeisBusiness, false);
    switchAppMode();
  }

  Future<void> switchAppMode() async {
    bool isBusiness =
        sharedPrefs.getBool(SharedPrefCons.appModeisBusiness) ?? false;
    if (isBusiness) {
      emit(AppModeSwitchingToBusiness());
      await Future.delayed(Duration(seconds: 1));
      emit(AppModeBusiness());
    } else {
      emit(AppModeSwitchingToNormalUser());
      await Future.delayed(Duration(seconds: 1));
      emit(AppModeNormalUser());
    }
  }
}
