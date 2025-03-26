part of 'create_event_bloc.dart';

@immutable
sealed class EventEvent {}

class CreateEventEvent extends EventEvent {
  final EventModel event;

  CreateEventEvent({required this.event});
}
