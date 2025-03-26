part of 'requested_events_bloc.dart';

@immutable
sealed class RequestedEventsEvent {}

final class FetchRequestedEvent extends RequestedEventsEvent {}

