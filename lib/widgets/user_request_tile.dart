import 'package:flutter/material.dart';
import 'package:auditoria/models/user_model.dart';
import 'package:auditoria/widgets/custom_button.dart';
import 'package:auditoria/utils/custom_text_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserRequestTile extends StatelessWidget {
  const UserRequestTile({
    super.key,
    required this.user,
    this.onAccept,
    this.onReject,
    this.onViewDetails,
    required this.index,
    required this.animationController,
  });

  final AnimationController animationController;
  final int index;
  final UserModel user;
  final GestureTapCallback? onAccept;
  final GestureTapCallback? onReject;
  final GestureTapCallback? onViewDetails;

  @override
  Widget build(BuildContext context) {
    double animationStart = (0.1 * index).clamp(0.0, 0.9);
    double animationEnd = (animationStart + 0.4).clamp(0.0, 1.0);

    return SlideTransition(
      position: Tween<Offset>(
              begin: const Offset(0, 2), end: const Offset(0, 0))
          .animate(CurvedAnimation(
              parent: animationController,
              curve:
                  Interval(animationStart, animationEnd, curve: Curves.ease))),
      child: FadeTransition(
        opacity:
            CurvedAnimation(parent: animationController, curve: Curves.ease),
        child: Card(
          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        "${user.firstName} ${user.lastName}",
                        style: CustomTextstyles.medium
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                _detailTile(icon: Icons.email, text: user.email!),
                SizedBox(height: 8.h),
                _detailTile(icon: Icons.badge_outlined, text: user.prnNumber!),
                SizedBox(height: 8.h),
                _detailTile(icon: Icons.phone, text: user.phoneNumber!),
                SizedBox(height: 12.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    smallButton(
                      text: "Accept",
                      color: Colors.green,
                      paddingVertical: 10.h,
                      paddingHorizontal: 15.w,
                      onTap: onAccept!,
                    ),
                    SizedBox(width: 10.w),
                    smallButton(
                      text: "Reject",
                      color: Colors.redAccent,
                      paddingVertical: 10.h,
                      paddingHorizontal: 15.w,
                      onTap: onReject!,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _detailTile({required IconData icon, required String text}) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.blue),
        SizedBox(width: 8.w),
        Text(
          text,
          style: CustomTextstyles.regular.copyWith(
            fontSize: 15.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
