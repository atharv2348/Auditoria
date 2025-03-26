import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auditoria/models/event_model.dart';
import 'package:auditoria/utils/custom_colors.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:auditoria/utils/custom_text_styles.dart';
import 'package:auditoria/widgets/event_request_tile.dart';
import 'package:auditoria/widgets/event_details_sheet.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:auditoria/blocs/fetch_my_events/fetch_my_events_bloc.dart';

class MyEventsPage extends StatefulWidget {
  const MyEventsPage({super.key});

  @override
  State<MyEventsPage> createState() => _MyEventsPageState();
}

class _MyEventsPageState extends State<MyEventsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    Timer(const Duration(milliseconds: 200),
        () => _animationController.forward());
    context.read<FetchMyEventsBloc>().add(FetchEvents());
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
                      "My events",
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
                    context.read<FetchMyEventsBloc>().add(FetchEvents());
                  },
                  child: BlocBuilder<FetchMyEventsBloc, FetchMyEventsState>(
                    builder: (context, state) {
                      if (state is FetchMyEventsLoadingState) {
                        return const Align(
                          alignment: Alignment.center,
                          child: Center(
                            child: SpinKitFadingCircle(color: Colors.black45),
                          ),
                        );
                      } else if (state is FetchMyEventsErrorState) {
                        return Center(
                          child: Text(state.error),
                        );
                      } else if (state is FetchMyEventsSuccessState) {
                        List<EventModel> myEvents = state.userEvents;
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
