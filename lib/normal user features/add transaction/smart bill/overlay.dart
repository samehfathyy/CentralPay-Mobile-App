
import 'package:budgeta/normal%20user%20features/add%20transaction/smart%20bill/cubit/smart_bill_capture_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScanningOverlay extends StatefulWidget {
  const ScanningOverlay({super.key});

  @override
  State<ScanningOverlay> createState() => _ScanningOverlayState();
}

class _ScanningOverlayState extends State<ScanningOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    context.read<SmartBillCaptureCubit>().captureImageAndSendItToAI(context);
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true); // This makes it go up AND down
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocListener<SmartBillCaptureCubit, SmartBillCaptureState>(
        listener: (context, state) {
          // TODO: implement listener
          if (state is SmartBillCaptureSuccess) {
            Navigator.pop(context);
          }
        },
        child: BlocBuilder<SmartBillCaptureCubit, SmartBillCaptureState>(
          builder: (context, state) {
            if (state is SmartBillCaptureLoading) {
              return Stack(
                children: [
                  // 1. The Captured Image
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: FileImage(state.imageFile!),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  // 2. The Moving Line
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Positioned(
                        top:
                            _controller.value *
                            MediaQuery.of(context).size.height *
                            0.8,
                        left: 20.w,
                        right: 20.w,
                        child: child!,
                      );
                    },
                    child: Container(
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blueAccent.withOpacity(0.5),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
