import 'package:auditoria/utils/custom_colors.dart';
import 'package:auditoria/utils/custom_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class DeveloperPage extends StatelessWidget {
  const DeveloperPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              SizedBox(height: 20.h),
              GestureDetector(
                onTap: () {
                  context.pop();
                  HapticFeedback.vibrate();
                },
                child: Row(
                  children: [
                    const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: CustomColors.color5,
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      "Developers",
                      style: CustomTextstyles.medium.copyWith(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
