import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:budgeta/core/network/api_result.dart';
import 'package:budgeta/core/network/api_service.dart';
import 'package:budgeta/normal%20user%20features/add%20transaction/smart%20bill/smart_bill_capture_response.dart';
import 'package:budgeta/normal%20user%20features/add%20transaction/ui/add_transaction_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

part 'smart_bill_capture_state.dart';

class SmartBillCaptureCubit extends Cubit<SmartBillCaptureState> {
  SmartBillCaptureCubit(this._apiService) : super(SmartBillCaptureInitial());
  final ApiService _apiService;
  Future<void> captureImageAndSendItToAI(BuildContext context) async {
    emit(SmartBillCaptureInitial());
    if (!await Permission.camera.isGranted) {
      await Permission.camera.request();
    }
    XFile? image = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 1200,
    );
    if (image == null) {
      emit(
        SmartBillCaptureFaliure(
          msg: "Error occured while processing your image, try again later",
        ),
      );
      return;
    }
    print("image path${image.path}");
    print(image.name);
    emit(SmartBillCaptureLoading(imageFile: File(image.path)));
    final result = await sendImage(image);
    result.when(
      success: (data) async {
        emit(SmartBillCaptureSuccess());
        await Future.delayed(const Duration(milliseconds: 100));
        print("returned data");
        print(data.extractedData?.category ?? "");
        print(data.extractedData?.total ?? 0.0);
        print(data.extractedData?.date_epoch_ms ?? "");

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddTransactionScreen(
              onSaveCallBack: (i) {},
              category: data.extractedData?.category,
              amount: data.extractedData?.total,
              date: data.extractedData?.date_epoch_ms,
            ),
          ),
        );
        // context.read<AddTransactionCubit>().enterTransactionDetails(
        //   data.extractedData?.category ?? "",
        //   data.extractedData?.total ?? 0.0,
        //   data.extractedData?.date_epoch_ms ?? 0,
        // );
        return;
      },
      failure: (message) {
        emit(
          SmartBillCaptureFaliure(
            msg: "Error occured while processing your image, try again later",
          ),
        );
        return;
      },
    );
  }

  Future<ApiResult<SmartBillCaptureResponse>> sendImage(XFile image) async {
    try {
      final multipartFile = await MultipartFile.fromFile(
        image.path,
        filename: image.name,
        contentType: MediaType("image", "jpeg"),
      );
      print("multipart name${multipartFile.filename}");
      print("multipart content type: ${multipartFile.contentType}");

      final response = await _apiService.billImageToTransaction(
        File(image.path),
      );
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(e.toString());
    }
  }
}
