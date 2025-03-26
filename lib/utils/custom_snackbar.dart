import 'dart:async';
import 'package:auditoria/main.dart';
import 'package:flutter/material.dart';

import 'custom_colors.dart';

class CustomSnackbar {
  static Timer? _debounceTimer;

  static void _debouncedShowSnackbar(String message,
      {required Color backgroundColor,
      required Color textColor,
      required Duration duration}) {
    _debounceTimer?.cancel();

    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      final snackBar = SnackBar(
        content: Text(
          message,
          style: TextStyle(color: textColor),
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        duration: duration,
      );

      scaffoldMessengerKey.currentState?.showSnackBar(snackBar);
    });
  }

  static void showSuccessSnackbar(String message,
      {duration = const Duration(seconds: 3)}) {
    _debouncedShowSnackbar(
      message,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      duration: duration,
    );
  }

  static void showErrorSnackbar(String message,
      {duration = const Duration(seconds: 3)}) {
    _debouncedShowSnackbar(
      message,
      backgroundColor: CustomColors.color6,
      textColor: Colors.white,
      duration: duration,
    );
  }

  static void showInfoSnackbar(String message,
      {duration = const Duration(seconds: 3)}) {
    _debouncedShowSnackbar(
      message,
      backgroundColor: CustomColors.color1,
      textColor: Colors.black,
      duration: duration,
    );
  }

  static void showWarningSnackbar(String message,
      {duration = const Duration(seconds: 3)}) {
    _debouncedShowSnackbar(
      message,
      backgroundColor: CustomColors.color4,
      textColor: Colors.black,
      duration: duration,
    );
  }
}
