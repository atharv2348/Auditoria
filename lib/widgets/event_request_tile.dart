import 'package:auditoria/models/event_model.dart';
import 'package:auditoria/widgets/custom_button.dart';
import 'package:auditoria/utils/custom_colors.dart';
import 'package:auditoria/utils/custom_text_styles.dart';
import 'package:auditoria/utils/utility_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EventRequestTile extends StatelessWidget {
  const EventRequestTile({
    super.key,
    required this.event,
    this.onAccept,
    this.onReject,
    this.isShowAcceptButton = true,
    this.isShowRejectButton = true,
    this.onViewDetails,
    this.isShowStatus = true,
    required this.animationController,
    required this.index,
  });

  final GestureTapCallback? onViewDetails;
  final GestureTapCallback? onAccept;
  final GestureTapCallback? onReject;
  final bool isShowAcceptButton;
  final bool isShowRejectButton;
  final bool isShowStatus;
  final EventModel event;
  final int index;
  final AnimationController animationController;

  Color _getColorForStatus(String status) {
    switch (status) {
      case "requested":
        return Colors.blueAccent;
      case "approved":
        return Colors.green;
      case "rejected":
        return Colors.redAccent;

      default:
        return Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    double animationStart = (0.1 * index).clamp(0.0, 0.9);
    double animationEnd = (animationStart + 0.4).clamp(0.0, 1.0);

    return SlideTransition(
      position: Tween<Offset>(
              begin: const Offset(0, 0.5), end: const Offset(0, 0))
          .animate(CurvedAnimation(
              parent: animationController,
              curve:
                  Interval(animationStart, animationEnd, curve: Curves.ease))),
      child: FadeTransition(
        opacity: CurvedAnimation(parent: animationController, curve: Curves.ease),
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
                        event.title ?? "No Title",
                        style: CustomTextstyles.medium
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    if (isShowStatus)
                      Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.h, horizontal: 15.w),
                        decoration: BoxDecoration(
                          color: _getColorForStatus(event.status!)
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          event.status!,
                          style: CustomTextstyles.medium.copyWith(
                              fontSize: 12.sp,
                              color: _getColorForStatus(event.status!),
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  "Organizer: ${event.organizer ?? "Unknown"}",
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    const Icon(Icons.event, size: 18, color: Colors.blue),
                    const SizedBox(width: 4),
                    Text(
                      formatDateTime(event.startTime!),
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    const Icon(Icons.person, size: 18, color: Colors.green),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        "Requested by: ${event.userInfo?.firstName ?? "Unknown"} ${event.userInfo?.lastName ?? ""}",
                        style: const TextStyle(fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    if (isShowAcceptButton)
                      smallButton(
                        text: "Accept",
                        color: Colors.green,
                        paddingVertical: 10.h,
                        paddingHorizontal: 15.w,
                        onTap: onAccept!,
                      ),
                    SizedBox(width: 10.w),
                    if (isShowRejectButton)
                      smallButton(
                        text: "Reject",
                        color: Colors.redAccent,
                        paddingVertical: 10.h,
                        paddingHorizontal: 15.w,
                        onTap: onReject!,
                      ),
                    const Spacer(),
                    smallButton(
                      text: "View Details",
                      color: CustomColors.color5,
                      paddingVertical: 10.h,
                      paddingHorizontal: 15.w,
                      onTap: onViewDetails!,
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
}
