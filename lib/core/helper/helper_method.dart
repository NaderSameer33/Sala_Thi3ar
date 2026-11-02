import 'package:flutter/widgets.dart';
import 'package:toastification/toastification.dart';

void showToast({
  required BuildContext context,
  required String message,
  bool isError = false,
}) {
  toastification.show(
    context: context,
    type: isError ? ToastificationType.error : ToastificationType.success,

    title: Text(message),
    autoCloseDuration: const Duration(seconds: 3),
  );
} 

