import 'package:auditoria/utils/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomInputDecoration {
  static InputDecoration getDecoration(
      {required String labelText, Icon? icon}) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: const TextStyle(color: CustomColors.color5),
      enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: CustomColors.color1)),
      focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: CustomColors.color5)),
      suffixIcon: icon,
      suffixIconColor: CustomColors.color5,
      contentPadding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 16.h),
    );
  }
}
