import 'dart:async';

import 'package:auditoria/blocs/fetch_upcoming_events/fetch_upcoming_events_bloc.dart';
import 'package:auditoria/models/event_model.dart';
import 'package:auditoria/widgets/event_details_sheet.dart';
import 'package:auditoria/widgets/event_request_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auditoria/utils/custom_colors.dart';
import 'package:auditoria/utils/custom_text_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UpcomingEventsPage extends StatefulWidget {
  const UpcomingEventsPage({super.key});

  @override
  State<UpcomingEventsPage> createState() => _UpcomingEventsPageState();
}

class _UpcomingEventsPageState extends State<UpcomingEventsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    Timer(const Duration(milliseconds: 200),
        () => _animationController.forward());
    context.read<FetchUpcomingEventsBloc>().add(FetchEvents());
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
                      "Upcoming events",
                      style: CustomTextstyles.medium.copyWith(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.grey.shade800,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  color: CustomColors.color5,
                  onRefresh: () async {
                    context.read<FetchUpcomingEventsBloc>().add(FetchEvents());
                  },
                  child: BlocBuilder<FetchUpcomingEventsBloc,
                      FetchUpcomingEventsState>(
                    builder: (context, state) {
                      if (state is FetchUpcomingEventsLoadingState) {
                        return const Align(
                          alignment: Alignment.center,
                          child: Center(
                            child: SpinKitFadingCircle(color: Colors.black45),
                          ),
                        );
                      } else if (state is FetchUpcomingEventsErrorState) {
                        return Center(
                          child: Text(state.error),
                        );
                      } else if (state is FetchUpcomingEventsSuccessState) {
                        List<EventModel> myEvents = state.upcomingEvents;
                        if (myEvents.isEmpty) {
                          return Center(
                            child: Text("No Events found",
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
                            itemCount: myEvents.length,
                            itemBuilder: (context, index) {
                              return EventRequestTile(
                                animationController: _animationController,
                                event: myEvents[index],
                                index: index,
                                onViewDetails: () {
                                  showEventDetailsSheet(
                                      context, myEvents[index]);
                                },
                                isShowAcceptButton: false,
                                isShowRejectButton: false,
                                isShowStatus: false,
                              );
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
            ],
          ),
        ),
      ),
    );
  }
}
