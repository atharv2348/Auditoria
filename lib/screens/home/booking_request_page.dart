import 'dart:async';

import 'package:auditoria/blocs/fetch_booked_events/fetch_booked_events_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auditoria/models/event_model.dart';
import 'package:auditoria/utils/custom_colors.dart';
import 'package:auditoria/widgets/custom_button.dart';
import 'package:auditoria/utils/custom_snackbar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:auditoria/utils/custom_text_styles.dart';
import 'package:auditoria/widgets/event_request_tile.dart';
import 'package:auditoria/widgets/event_details_sheet.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:auditoria/widgets/custom_loading_overlay.dart';
import 'package:auditoria/blocs/requested_events/requested_events_bloc.dart';
import 'package:auditoria/cubits/update_event_status/update_event_status_cubit.dart';

class BookingRequestPage extends StatefulWidget {
  const BookingRequestPage({super.key});

  @override
  State<BookingRequestPage> createState() => _BookingRequestPageState();
}

class _BookingRequestPageState extends State<BookingRequestPage>
    with SingleTickerProviderStateMixin {
  final OverlayPortalController _overlayPortalController =
      OverlayPortalController();
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    Timer(const Duration(milliseconds: 200),
        () => _animationController.forward());
    context.read<RequestedEventBloc>().add(FetchRequestedEvent());
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

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
                      "Booking Requests",
                      style: CustomTextstyles.medium.copyWith(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              Expanded(
                child: RefreshIndicator(
                  color: CustomColors.color5,
                  onRefresh: () async {
                    context
                        .read<RequestedEventBloc>()
                        .add(FetchRequestedEvent());
                  },
                  child: BlocBuilder<RequestedEventBloc, RequestedEventsState>(
                    builder: (context, state) {
                      if (state is FetchRequestedEventsLoadingState) {
                        return const Align(
                          alignment: Alignment.center,
                          child: Center(
                            child: SpinKitFadingCircle(color: Colors.black45),
                          ),
                        );
                      } else if (state is FetchRequestedEventsErrorState) {
                        return Center(
                          child: Text(state.error),
                        );
                      } else if (state is FetchRequestedEventsSuccessState) {
                        List<EventModel> requestedEvents =
                            state.requestedEvents;
                        if (requestedEvents.isEmpty) {
                          return Center(
                            child: Text("No booking requests found",
                                style: CustomTextstyles.medium),
                          );
                        }
                        _animationController.reset();
                        _animationController.forward();

                        return ShaderMask(
                          shaderCallback: (Rect bounds) {
                            return const LinearGradient(
                              stops: [0.0, 0.05],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: <Color>[Colors.white10, Colors.white],
                            ).createShader(bounds);
                          },
                          child: ListView.builder(
                            padding: EdgeInsets.only(top: 10.h, bottom: 15.h),
                            itemCount: requestedEvents.length,
                            itemBuilder: (context, index) {
                              return EventRequestTile(
                                  animationController: _animationController,
                                  event: requestedEvents[index],
                                  isShowStatus: false,
                                  index: index,
                                  onAccept: () {
                                    _showConfirmationDialog(
                                      isAccepting: true,
                                      onConfirm: () {
                                        // call accept api
                                        context.pop();
                                        context
                                            .read<UpdateEventStatusCubit>()
                                            .updateStatusOfRequested(
                                                eventId:
                                                    requestedEvents[index].id!,
                                                isApprove: true);
                                        context
                                            .read<FetchBookedEventsBloc>()
                                            .add(FetchEvents());
                                      },
                                    );
                                  },
                                  onReject: () {
                                    _showConfirmationDialog(
                                      isAccepting: false,
                                      onConfirm: () {
                                        // call reject api
                                        context.pop();
                                        _showRejectionReasonDialog(
                                          onConfirm: (reason) {
                                            context
                                                .read<UpdateEventStatusCubit>()
                                                .updateStatusOfRequested(
                                                    eventId:
                                                        requestedEvents[index]
                                                            .id!,
                                                    isApprove: false,
                                                    reason: reason);
                                          },
                                        );
                                      },
                                    );
                                  },
                                  onViewDetails: () {
                                    showEventDetailsSheet(
                                        context, requestedEvents[index]);
                                  });
                            },
                          ),
                        );
                      } else {
                        return const Center(child: Text("No data"));
                      }
                    },
                  ),
                ),
              ),
              BlocListener<UpdateEventStatusCubit, UpdateEventStatusState>(
                listener: (context, state) {
                  if (state is UpdateStatusOfRequestedEventsLoadingState) {
                    _overlayPortalController.show();
                  } else {
                    _overlayPortalController.hide();
                  }

                  if (state is UpdateStatusOfRequestedEventsSuccessState) {
                    if (state.isSuccess) {
                      context
                          .read<RequestedEventBloc>()
                          .add(FetchRequestedEvent());

                      CustomSnackbar.showSuccessSnackbar(state.message);
                    } else {
                      CustomSnackbar.showErrorSnackbar(state.message);
                    }
                  } else if (state is UpdateStatusOfRequestedEventsErrorState) {
                    CustomSnackbar.showErrorSnackbar(state.error);
                  }
                },
                child: CustomLoadingOverlay(
                    overlayPortalController: _overlayPortalController),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showConfirmationDialog({
    required bool isAccepting,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          isAccepting ? "Accept Event Request?" : "Reject Event Request?",
          style: CustomTextstyles.subHeading.copyWith(
            color: CustomColors.color5,
          ),
        ),
        content: Text(
          isAccepting
              ? "Are you sure you want to accept this event request?"
              : "Are you sure you want to reject this event request?",
          style: CustomTextstyles.regular.copyWith(color: Colors.grey.shade800),
        ),
        actions: [
          smallButton(
            text: "Cancel",
            color: CustomColors.disabled,
            paddingVertical: 10.h,
            paddingHorizontal: 15.w,
            onTap: () {
              context.pop();
            },
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

  void _showRejectionReasonDialog({required Function(String) onConfirm}) {
    TextEditingController reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Reason for Rejection",
          style: CustomTextstyles.subHeading.copyWith(
            color: CustomColors.color5,
          ),
        ),
        content: TextField(
          maxLines: 3,
          controller: reasonController,
          keyboardType: TextInputType.multiline,
          decoration: const InputDecoration(
            hintText: "Enter the reason",
            hintStyle: TextStyle(color: CustomColors.color5),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: CustomColors.color1)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: CustomColors.color5)),
          ),
        ),
        actions: [
          smallButton(
            text: "Cancel",
            color: CustomColors.disabled,
            paddingVertical: 10.h,
            paddingHorizontal: 15.w,
            onTap: () {
              context.pop();
            },
          ),
          smallButton(
            text: "Submit",
            color: CustomColors.color5,
            paddingVertical: 10.h,
            paddingHorizontal: 15.w,
            onTap: () {
              if (reasonController.text.trim().isEmpty) {
                CustomSnackbar.showWarningSnackbar(
                    "Please enter a reason for rejection");
                return;
              }
              context.pop();
              onConfirm(reasonController.text.trim());
            },
          ),
        ],
      ),
    );
  }
}
