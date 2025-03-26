import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:auditoria/utils/routes.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auditoria/models/user_model.dart';
import 'package:auditoria/router/app_router.dart';
import 'package:auditoria/models/event_model.dart';
import 'package:auditoria/widgets/event_tile.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:auditoria/utils/custom_colors.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:auditoria/utils/custom_text_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:auditoria/cubits/get_user_details/get_user_details_cubit.dart';
import 'package:auditoria/blocs/fetch_booked_events/fetch_booked_events_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final TextEditingController eventController = TextEditingController();
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  final DateTime _focusedDay = DateTime.now();
  final ValueNotifier<DateTime> _selectedDay = ValueNotifier<DateTime>(
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day));
  final ValueNotifier<List<EventModel>> _selectedEvent = ValueNotifier([]);
  final Map<DateTime, List<EventModel>> events = {};
  late AnimationController _animationController;
  late UserModel user;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    Timer(const Duration(milliseconds: 200),
        () => _animationController.forward());
    context.read<FetchBookedEventsBloc>().add(FetchEvents());
    context.read<GetUserDetailsCubit>().getUserDetailsFromLocalStorage();
  }

  List<EventModel> _getEventsForDay(DateTime day) {
    DateTime normalizedDay = DateTime(day.year, day.month, day.day);
    return events[normalizedDay] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    DateTime normalizedSelectedDay =
        DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
    if (normalizedSelectedDay == _selectedDay.value) return;
    _selectedDay.value = normalizedSelectedDay;
    _animationController.reset();
    _animationController.forward();
    _selectedEvent.value = _getEventsForDay(normalizedSelectedDay);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page",
            style: CustomTextstyles.medium.copyWith(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.grey.shade800,
                fontWeight: FontWeight.bold)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(15.r)),
        ),
      ),
      floatingActionButton:
          BlocBuilder<GetUserDetailsCubit, GetUserDetailsState>(
        builder: (context, state) {
          if (state is UserGetDetailsFromStorageSuccessState) {
            return state.user.hasBookingAccess!
                ? Padding(
                    padding: EdgeInsets.only(right: 10.w, bottom: 10.h),
                    child: FloatingActionButton(
                      backgroundColor: CustomColors.color1,
                      onPressed: () {
                        router.push(Routes.eventFormPage);
                      },
                      child: const Icon(Icons.add),
                    ),
                  )
                : const SizedBox.shrink();
          }
          return const SizedBox.shrink();
        },
      ),
      drawer: Drawer(
        child: BlocBuilder<GetUserDetailsCubit, GetUserDetailsState>(
          builder: (context, state) {
            if (state is UserGetDetailsFromStorageLoadingState) {
              return const Center(
                child: SpinKitFadingCircle(color: Colors.black45),
              );
            } else if (state is UserGetDetailsFromStorageSuccessState) {
              user = state.user;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    // height: 250.h,
                    width: double.maxFinite,
                    decoration: const BoxDecoration(
                      color: CustomColors.color1,
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                              height:
                                  MediaQuery.of(context).padding.top + 10.h),
                          Align(
                            alignment: Alignment.center,
                            child: SvgPicture.asset(
                              './assets/images/logo.svg',
                              semanticsLabel: 'App Logo',
                              height: 100.h,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Text(state.user.firstName!,
                              style: CustomTextstyles.subHeading
                                  .copyWith(color: Colors.grey.shade800)),
                          Text(state.user.email!,
                              overflow: TextOverflow.ellipsis,
                              style: CustomTextstyles.medium
                                  .copyWith(color: Colors.grey.shade800)),
                          SizedBox(height: 20.h),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  drawerTile(
                    icon: Icons.person_rounded,
                    title: "Profile",
                    onTap: () {
                      router.push(Routes.profilePage, extra: user);
                    },
                  ),
                  if (state.user.role == 'Admin')
                    drawerTile(
                      icon: Icons.assignment_rounded,
                      title: "Booking Requests",
                      onTap: () {
                        context.push(Routes.bookingRequestPage);
                      },
                    ),
                  if (state.user.role != 'admin')
                    drawerTile(
                      icon: Icons.lock_person_rounded,
                      title: "Access Requests",
                      onTap: () {
                        context.push(Routes.accessRequestPage);
                      },
                    ),
                  drawerTile(
                    icon: Icons.event_available_rounded,
                    title: "My Events",
                    onTap: () {
                      context.push(Routes.myEventsPage);
                    },
                  ),
                  // drawerTile(
                  //     icon: Icons.code_rounded,
                  //     title: "Developers",
                  //     onTap: () {
                  //       context.push(Routes.developerPage);
                  //     }),
                  drawerTile(
                    icon: Icons.feedback_outlined,
                    title: "Feedback",
                    onTap: () {
                      context.push(Routes.feedbackPage);
                    },
                  ),

                  const Spacer(),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.h),
                      child: Text(
                        "© 2025 Auditoria.\nAll rights reserved.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h)
                ],
              );
            } else if (state is UserGetDetailsFromStorageErrorState) {
              return Center(
                child: Text(state.error),
              );
            } else {
              return const Center(
                child: Text("No data"),
              );
            }
          },
        ),
      ),
      body: BlocBuilder<FetchBookedEventsBloc, FetchBookedEventsState>(
        builder: (context, state) {
          if (state is FetchBookedEventsLoadingState) {
            return const Center(
              child: SpinKitFadingCircle(color: Colors.black45),
            );
          } else if (state is FetchBookedEventsErrorState) {
            return Center(child: Text(state.error));
          } else if (state is FetchBookedEventsSuccessState) {
            events.clear();
            for (var event in state.bookedEvents) {
              if (event.startTime != null) {
                DateTime dateTime = DateTime.parse(event.startTime!);
                DateTime normalizedDate =
                    DateTime(dateTime.year, dateTime.month, dateTime.day);
                events.putIfAbsent(normalizedDate, () => []).add(event);
              }
            }
            _selectedEvent.value = _getEventsForDay(_selectedDay.value);

            return RefreshIndicator(
              color: CustomColors.color5,
              onRefresh: () async {
                context.read<FetchBookedEventsBloc>().add(FetchEvents());
              },
              child: Column(
                children: [
                  // Calendar
                  ValueListenableBuilder(
                    valueListenable: _selectedDay,
                    builder: (context, value, child) {
                      return TableCalendar(
                        daysOfWeekHeight: 30.h,
                        focusedDay: _focusedDay,
                        firstDay: DateTime(2020, 1, 1),
                        lastDay: DateTime(2030, 12, 31),
                        calendarFormat: _calendarFormat,
                        headerStyle: const HeaderStyle(
                          formatButtonVisible: false,
                          titleCentered: true,
                        ),
                        calendarStyle: CalendarStyle(
                          selectedDecoration: const BoxDecoration(
                            color: CustomColors.color5,
                            shape: BoxShape.circle,
                          ),
                          todayDecoration: BoxDecoration(
                            color: CustomColors.color5.withOpacity(0.7),
                            shape: BoxShape.circle,
                          ),
                          selectedTextStyle: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        availableGestures: AvailableGestures.all,
                        selectedDayPredicate: (day) => isSameDay(day, value),
                        onDaySelected: _onDaySelected,
                        eventLoader: _getEventsForDay,
                        calendarBuilders: CalendarBuilders(
                          markerBuilder: (context, date, events) {
                            if (events.isEmpty) return const SizedBox.shrink();
                            int maxDots = 3;

                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                for (int i = 0;
                                    i < maxDots && i < events.length;
                                    i++)
                                  _buildMarker(),
                                if (events.length >= 4)
                                  Text(
                                    "+${events.length - maxDots}",
                                    style: TextStyle(
                                        fontSize: 10.sp,
                                        color: CustomColors.color6),
                                  )
                              ],
                            );
                          },
                        ),
                      );
                    },
                  ),
                  // Event list by day
                  Expanded(
                    child: ShaderMask(
                      shaderCallback: (Rect bounds) {
                        return const LinearGradient(
                          stops: [0.0, 0.15],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: <Color>[Colors.white10, Colors.white],
                        ).createShader(bounds);
                      },
                      child: Padding(
                        padding:
                            EdgeInsets.only(top: 30.h, left: 16.w, right: 16.w),
                        child: ValueListenableBuilder(
                            valueListenable: _selectedEvent,
                            builder: (context, value, child) {
                              return ListView.builder(
                                itemCount: value.length,
                                itemBuilder: (context, index) {
                                  return EventTile(
                                    event: value[index],
                                    animationController: _animationController,
                                    index: index,
                                  );
                                },
                              );
                            }),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text("No data"));
          }
        },
      ),
    );
  }

  Widget _buildMarker() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      width: 6,
      height: 6,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: CustomColors.color6,
      ),
    );
  }

  Widget drawerTile(
      {required IconData icon,
      required String title,
      required GestureTapCallback onTap}) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.vibrate();
        onTap();
      },
      child: Card(
        child: Container(
          padding: EdgeInsets.all(10.h),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.r)),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: CustomColors.color5.withOpacity(0.2),
                child: Icon(icon, color: CustomColors.color5),
              ),
              SizedBox(width: 8.w),
              Text(title, style: CustomTextstyles.medium)
            ],
          ),
        ),
      ),
    );
  }
}
