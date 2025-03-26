import 'package:auditoria/models/event_model.dart';
import 'package:auditoria/widgets/custom_button.dart';
import 'package:auditoria/utils/custom_colors.dart';
import 'package:auditoria/utils/utility_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void showEventDetailsSheet(BuildContext context, EventModel event) {
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
    ),
    backgroundColor: Colors.white,
    isScrollControlled: true,
    builder: (context) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 50.w,
                  height: 5.h,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 15.h),
              Text(
                event.title ?? "No Title",
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: CustomColors.color5,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                event.description ?? "No Description",
                style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade700),
              ),
              SizedBox(height: 10.h),
              _eventDetailRow(
                  Icons.event, "Start Time", formatDateTime(event.startTime!)),
              _eventDetailRow(
                  Icons.event, "End Time", formatDateTime(event.endTime!)),
              _eventDetailRow(
                  Icons.person, "Organizer", event.organizer ?? "Unknown"),
              _eventDetailRow(Icons.people, "Expected Attendees",
                  event.expectedAttendees.toString()),
              _eventDetailRow(
                  Icons.email, "Contact Email", event.contactEmail ?? "N/A"),
              _eventDetailRow(Icons.phone, "Contact Phone",
                  event.contactPhoneNumber ?? "N/A"),
              if (event.instructions!.isNotEmpty)
                _eventDetailRow(Icons.info_outline, "Instructions",
                    event.instructions ?? "No Instructions"),
              SizedBox(height: 20.h),
              Align(
                alignment: Alignment.center,
                child: smallButton(
                  text: "Close",
                  color: CustomColors.color6,
                  paddingVertical: 15.h,
                  paddingHorizontal: 20.w,
                  onTap: () => Navigator.pop(context),
                ),
              ),
              SizedBox(height: 10.h),
            ],
          ),
        ),
      );
    },
  );
}

Widget _eventDetailRow(IconData icon, String label, String value) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 6.h),
    child: Row(
      children: [
        Icon(icon, size: 20.sp, color: CustomColors.color5),
        SizedBox(width: 10.w),
        Text(
          "$label: ",
          style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              overflow: TextOverflow.ellipsis),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                overflow: TextOverflow.ellipsis),
          ),
        ),
      ],
    ),
  );
}
