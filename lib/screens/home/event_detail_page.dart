import 'package:flutter/material.dart';
import 'package:auditoria/models/event_model.dart';
import 'package:auditoria/utils/utility_functions.dart';
import 'package:auditoria/utils/custom_text_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EventDetailPage extends StatelessWidget {
  final EventModel event;

  const EventDetailPage({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Event Details"),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(15.r)),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event Title
            Text(
              event.title ?? "Unknown Event",
              style: CustomTextstyles.subHeading.copyWith(fontSize: 20.sp),
            ),
            SizedBox(height: 10.h),

            // Event Date & Time
            Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.grey, size: 18),
                SizedBox(width: 6.w),
                Text(
                  formatDateTime(event.startTime!),
                  style: CustomTextstyles.medium.copyWith(fontSize: 14.sp),
                ),
              ],
            ),
            SizedBox(height: 10.h),

            // Event Description
            Text(
              "About the Event",
              style: CustomTextstyles.subHeading.copyWith(fontSize: 16.sp),
            ),
            SizedBox(height: 6.h),
            Text(
              event.description ?? "No description available",
              style: CustomTextstyles.medium.copyWith(
                fontSize: 14.sp,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
