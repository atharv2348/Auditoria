part of 'fetch_booked_events_bloc.dart';

@immutable
sealed class FetchBookedEventsState {}

final class FetchBookedEventsInitial extends FetchBookedEventsState {}

// ------------- Fetch All Booked Events States ------------- //

final class FetchBookedEventsLoadingState extends FetchBookedEventsState {}

final class FetchBookedEventsErrorState extends FetchBookedEventsState {
  final String error;

  FetchBookedEventsErrorState({required this.error});
}

final class FetchBookedEventsSuccessState extends FetchBookedEventsState {
  final List<EventModel> bookedEvents;

  FetchBookedEventsSuccessState({required this.bookedEvents});
}
