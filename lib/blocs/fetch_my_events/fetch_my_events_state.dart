part of 'fetch_my_events_bloc.dart';

@immutable
sealed class FetchMyEventsState {}

final class FetchMyEventsInitial extends FetchMyEventsState {}

// ------------- Fetch All User Events States ------------- //

final class FetchMyEventsLoadingState extends FetchMyEventsState {}

final class FetchMyEventsErrorState extends FetchMyEventsState {
  final String error;

  FetchMyEventsErrorState({required this.error});
}

final class FetchMyEventsSuccessState extends FetchMyEventsState {
  final List<EventModel> userEvents;

  FetchMyEventsSuccessState({required this.userEvents});
}
