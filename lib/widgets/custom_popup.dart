import 'package:auditoria/utils/custom_colors.dart';
import 'package:auditoria/utils/custom_text_styles.dart';
import 'package:auditoria/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void showConfirmationDialog({
  required BuildContext context,
  required String title,
  required String content,
  required GestureTapCallback onConfirm,
  required GestureTapCallback onCancel,
}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(
        title,
        style: CustomTextstyles.medium.copyWith(
          color: CustomColors.color5,
        ),
      ),
      content: Text(
        content,
        style: CustomTextstyles.regular.copyWith(),
      ),
      actions: [
        smallButton(
          text: "Cancel",
          color: CustomColors.disabled,
          paddingVertical: 10.h,
          paddingHorizontal: 15.w,
          onTap: onCancel,
        ),
        smallButton(
          text: "Confirm",
          color: CustomColors.color5,
          paddingVertical: 10.h,
          paddingHorizontal: 15.w,
          onTap: onConfirm,
        ),
      ],
    ),
  );
}
