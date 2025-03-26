import 'package:auditoria/utils/custom_colors.dart';
import 'package:auditoria/utils/custom_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neopop/neopop.dart';

Widget customNeoPopButton({
  required String text,
  required VoidCallback? onTap,
  bool enabled = true,
  Color color = CustomColors.color5,
}) {
  return NeoPopButton(
    color: color,
    bottomShadowColor: Colors.grey.shade700,
    rightShadowColor: Colors.grey.shade700,
    leftShadowColor: Colors.green,
    onTapUp: onTap,
    onTapDown: () => HapticFeedback.vibrate(),
    disabledColor: CustomColors.disabled,
    enabled: enabled,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade900,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget smallButton({
  required String text,
  required Color color,
  required double paddingVertical,
  required double paddingHorizontal,
  required GestureTapCallback onTap,
}) {
  return GestureDetector(
    onTap: () {
      HapticFeedback.vibrate();
      onTap();
    },
    child: Container(
      padding: EdgeInsets.symmetric(
          vertical: paddingVertical, horizontal: paddingHorizontal),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        text,
        style: CustomTextstyles.medium.copyWith(
            fontSize: 12.sp, color: color, fontWeight: FontWeight.w600),
      ),
    ),
  );
}
