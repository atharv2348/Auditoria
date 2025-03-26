import 'package:auditoria/models/event_model.dart';
import 'package:auditoria/utils/custom_colors.dart';
import 'package:auditoria/utils/custom_text_styles.dart';
import 'package:auditoria/utils/utility_functions.dart';
import 'package:auditoria/widgets/event_details_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EventTile extends StatelessWidget {
  final EventModel event;
  final int index;
  final AnimationController animationController;
  const EventTile({
    super.key,
    required this.event,
    required this.animationController,
    required this.index,
  });

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
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 6.h, horizontal: 10.w),
          padding: EdgeInsets.all(14.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                spreadRadius: 2,
                offset: const Offset(0, 3),
              ),
            ],
            border: Border.all(color: CustomColors.color1, width: 1.2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.event, color: CustomColors.color1, size: 20),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      event.title ?? "Unknown Title",
                      style:
                          CustomTextstyles.subHeading.copyWith(fontSize: 16.sp),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 6.h),
              Text(
                event.description ?? "No description available",
                style: CustomTextstyles.medium.copyWith(
                  fontSize: 14.sp,
                  color: Colors.black87,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.access_time,
                          size: 18, color: Colors.grey),
                      SizedBox(width: 4.w),
                      Text(
                        formatDateTime(event.startTime!),
                        style: CustomTextstyles.medium.copyWith(
                          fontSize: 12.sp,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => showEventDetailsSheet(context, event),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 4.h, horizontal: 10.w),
                      decoration: BoxDecoration(
                        color: CustomColors.color4.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        "View Details",
                        style: CustomTextstyles.medium.copyWith(
                          fontSize: 12.sp,
                          color: CustomColors.color5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
