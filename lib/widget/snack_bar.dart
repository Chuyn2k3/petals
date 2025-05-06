import 'package:flutter/material.dart';
import 'package:petals/constant/constant.dart';


import 'package:toastification/toastification.dart';

extension Snackbar on BuildContext {
  void showSnackBarSuccess({
    String? title,
    required String text,
  }) {
    _showToast(
      title: title ?? "Thành công",
      type: ToastificationType.success,
      text: text,
    );
  }

  void showSnackBarFail({
    required String text,
    String? title,
  }) {
    _showToast(
      title: title ?? "Thất bại",
      type: ToastificationType.error,
      text: text,
    );
  }

  void showSnackBarInfo({
    required String text,
    String? title,
  }) {
    _showToast(
      title: title ?? "Thông báo",
      type: ToastificationType.info,
      text: text,
    );
  }

  void _showToast({
    required String text,
    required String title,
    required ToastificationType type,
  }) {
    toastification.show(
      context: this,
      type: type,
      style: ToastificationStyle.fillColored,
      title: Text(title),
      description: Text(text),
      alignment: Alignment.topRight,
      autoCloseDuration: const Duration(seconds: 4),
      borderRadius: BorderRadius.circular(12.0),
      boxShadow: highModeShadow,
      closeOnClick: false,
      showProgressBar: false,
      dragToClose: true,
    );
  }

  void showSnackBar({required String text, int? type}) {
    switch (type) {
      case Const.messageError:
        showSnackBarFail(text: text);
        break;
      default:
        showSnackBarSuccess(text: text);
        break;
    }
  }
}
