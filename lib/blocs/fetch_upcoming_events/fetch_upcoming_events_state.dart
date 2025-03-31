part of 'fetch_upcoming_events_bloc.dart';

@immutable
sealed class FetchUpcomingEventsState {}

final class FetchUpcomingEventsInitial extends FetchUpcomingEventsState {}

// ------------- Fetch Upcoming Events States ------------- //

final class FetchUpcomingEventsLoadingState extends FetchUpcomingEventsInitial {}

final class FetchUpcomingEventsErrorState extends FetchUpcomingEventsInitial {
  final String error;

  FetchUpcomingEventsErrorState({required this.error});
}

final class FetchUpcomingEventsSuccessState extends FetchUpcomingEventsInitial {
  final List<EventModel> upcomingEvents;

  FetchUpcomingEventsSuccessState({required this.upcomingEvents});
}
