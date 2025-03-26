part of 'requested_events_bloc.dart';

@immutable
sealed class RequestedEventsState {}

final class RequestedEventsInitial extends RequestedEventsState {}

// ------------- Fetch All Requested Events States ------------- //

final class FetchRequestedEventsLoadingState
    extends RequestedEventsState {}

final class FetchRequestedEventsErrorState extends RequestedEventsState {
  final String error;

  FetchRequestedEventsErrorState({required this.error});
}

final class FetchRequestedEventsSuccessState extends RequestedEventsState {
  final List<EventModel> requestedEvents;

  FetchRequestedEventsSuccessState({required this.requestedEvents});
}
