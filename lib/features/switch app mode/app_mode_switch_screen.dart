import 'package:budgeta/core/theming/App_Colors.dart';
import 'package:budgeta/features/switch%20app%20mode/cubit/app_mode_cubit.dart';
import 'package:budgeta/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class AppModeSwitchScreen extends StatefulWidget {
  const AppModeSwitchScreen({super.key});

  @override
  State<AppModeSwitchScreen> createState() => _AppModeSwitchScreenState();
}

class _AppModeSwitchScreenState extends State<AppModeSwitchScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<AppModeCubit>().switchAppMode();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppModeCubit, AppModeState>(
      builder: (context, state) {
        if (state is AppModeSwitchingToBusiness ||
            state is AppModeSwitchingToNormalUser) {
          return Scaffold(
            body: Center(
              child: LoadingAnimationWidget.hexagonDots(
                color: AppColors.blue,
                size: 40,
              ),
            ),
          );
        }
        if (state is AppModeBusiness) {
          return BusinessApp();
        }
        if (state is AppModeNormalUser) {
          return NormalUserApp();
        }
        return Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
