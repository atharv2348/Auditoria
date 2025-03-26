import 'package:auditoria/models/event_model.dart';
import 'package:auditoria/models/user_model.dart';
import 'package:auditoria/screens/auth/email_page.dart';
import 'package:auditoria/screens/auth/otp_page.dart';
import 'package:auditoria/screens/auth/create_user_page.dart';
import 'package:auditoria/screens/home/access_request_page.dart';
import 'package:auditoria/screens/home/booking_request_page.dart';
import 'package:auditoria/screens/home/developer_page.dart';
import 'package:auditoria/screens/home/event_detail_page.dart';
import 'package:auditoria/screens/home/event_form_page.dart';
import 'package:auditoria/screens/home/feedback_page.dart';
import 'package:auditoria/screens/home/home_page.dart';
import 'package:auditoria/screens/home/my_events_page.dart';
import 'package:auditoria/screens/home/profile_page.dart';
import 'package:auditoria/screens/splash_screen.dart';
import 'package:auditoria/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  initialLocation: Routes.splashScreen,
  routes: [
    GoRoute(
      path: Routes.splashScreen,
      name: 'splash',
      pageBuilder: (context, state) => _buildPageWithTransition(
        state,
        const SplashScreen(),
      ),
    ),
    GoRoute(
      path: Routes.homeScreen,
      name: 'home',
      pageBuilder: (context, state) => _buildPageWithTransition(
        state,
        const HomePage(),
      ),
    ),
    GoRoute(
      path: Routes.emailScreen,
      name: 'email',
      pageBuilder: (context, state) => _buildPageWithTransition(
        state,
        const EmailPage(),
      ),
    ),
    GoRoute(
      path: Routes.otpScreen,
      name: 'otp',
      pageBuilder: (context, state) {
        final email = state.extra as String;
        return _buildPageWithTransition(state, OtpPage(email: email));
      },
    ),
    GoRoute(
      path: Routes.userDetailsScreen,
      name: 'createUser',
      pageBuilder: (context, state) {
        final email = state.extra as String;
        return _buildPageWithTransition(state, CreateUserPage(email: email));
      },
    ),
    GoRoute(
      path: Routes.eventFormPage,
      name: 'eventForm',
      pageBuilder: (context, state) =>
          _buildPageWithTransition(state, const EventFormPage()),
    ),
    GoRoute(
      path: Routes.eventDetailsPage,
      name: 'eventDetails',
      pageBuilder: (context, state) {
        final event = state.extra as EventModel;
        return _buildPageWithTransition(state, EventDetailPage(event: event));
      },
    ),
    GoRoute(
      path: Routes.profilePage,
      name: 'profile',
      pageBuilder: (context, state) {
        final user = state.extra as UserModel;
        return _buildPageWithTransition(state, ProfilePage(user: user));
      },
    ),
    GoRoute(
      path: Routes.bookingRequestPage,
      name: 'bookingRequest',
      pageBuilder: (context, state) =>
          _buildPageWithTransition(state, const BookingRequestPage()),
    ),
    GoRoute(
      path: Routes.accessRequestPage,
      name: 'accessRequest',
      pageBuilder: (context, state) =>
          _buildPageWithTransition(state, const AccessRequestPage()),
    ),
    GoRoute(
      path: Routes.myEventsPage,
      name: 'myEvents',
      pageBuilder: (context, state) =>
          _buildPageWithTransition(state, const MyEventsPage()),
    ),
    GoRoute(
      path: Routes.feedbackPage,
      name: 'feedback',
      pageBuilder: (context, state) =>
          _buildPageWithTransition(state, FeedbackPage()),
    ),
    GoRoute(
      path: Routes.developerPage,
      name: 'developer',
      pageBuilder: (context, state) =>
          _buildPageWithTransition(state, const DeveloperPage()),
    ),
  ],
);

CustomTransitionPage _buildPageWithTransition(
    GoRouterState state, Widget child) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 250),
    reverseTransitionDuration: const Duration(milliseconds: 250),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(opacity: animation, child: child);
      // return SlideTransition(
      //   position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
      //       .animate(animation),
      //   child: child,
      // );
    },
  );
}
