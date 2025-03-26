import 'package:auditoria/blocs/create_event_bloc/create_event_bloc.dart';
import 'package:auditoria/blocs/fetch_booked_events/fetch_booked_events_bloc.dart';
import 'package:auditoria/blocs/fetch_my_events/fetch_my_events_bloc.dart';
import 'package:auditoria/blocs/requested_access/requested_access_bloc.dart';
import 'package:auditoria/blocs/requested_events/requested_events_bloc.dart';
import 'package:auditoria/blocs/user_bloc/user_bloc.dart';
import 'package:auditoria/cubits/email_alert_toggle/email_alert_toggle_cubit.dart';
import 'package:auditoria/cubits/feedback/feedback_cubit.dart';
import 'package:auditoria/cubits/get_user_details/get_user_details_cubit.dart';
import 'package:auditoria/cubits/request_booking_access/request_booking_access_cubit.dart';
import 'package:auditoria/cubits/update_event_status/update_event_status_cubit.dart';
import 'package:auditoria/cubits/update_user_access/update_user_access_cubit.dart';
import 'package:auditoria/cubits/verify_token/verify_token_cubit.dart';
import 'package:auditoria/theme/theme_mode.dart';
import 'package:auditoria/utils/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:auditoria/router/app_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(450, 980),
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => UserBloc()),
            BlocProvider(create: (context) => CreateEventBloc()),
            BlocProvider(create: (context) => FetchBookedEventsBloc()),
            BlocProvider(create: (context) => RequestedEventBloc()),
            BlocProvider(create: (context) => RequestedAccessBloc()),
            BlocProvider(create: (context) => EmailAlertToggleCubit()),
            BlocProvider(create: (context) => UpdateEventStatusCubit()),
            BlocProvider(create: (context) => UpdateUserAccessCubit()),
            BlocProvider(create: (context) => RequestBookingAccessCubit()),
            BlocProvider(create: (context) => VerifyTokenCubit()),
            BlocProvider(create: (context) => GetUserDetailsCubit()),
            BlocProvider(create: (context) => FetchMyEventsBloc()),
            BlocProvider(create: (context) => FeedbackCubit()),
          ],
          child: AnimatedBuilder(
              animation: ThemeManager.themeNotifier,
              builder: (context, child) {
                return MaterialApp.router(
                  debugShowCheckedModeBanner: false,
                  title: 'Auditoria',
                  scaffoldMessengerKey: scaffoldMessengerKey,
                  // themeMode: ThemeManager.themeMode.value,
                  // theme: AppThemes.lightTheme,
                  // darkTheme: AppThemes.darkTheme,
                  darkTheme: ThemeData(
                    fontFamily: 'Poppins',
                    brightness: Brightness.dark,
                    scaffoldBackgroundColor: CustomColorsDark.color1,
                    appBarTheme: const AppBarTheme(
                      color: CustomColorsDark.color3,
                      centerTitle: true,
                    ),
                  ),
                  theme: ThemeData(
                    fontFamily: 'Poppins',
                    scaffoldBackgroundColor: CustomColors.color3,
                    appBarTheme: const AppBarTheme(
                      color: CustomColors.color1,
                      centerTitle: true,
                    ),
                  ),
                  // theme: AppThemes.lightTheme,
                  // darkTheme: AppThemes.darkTheme,
                  themeMode: ThemeManager.themeNotifier.value,
                  routerConfig: router,
                );
              }),
        );
      },
    );
  }
}
