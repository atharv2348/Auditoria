part of 'create_event_bloc.dart';

@immutable
sealed class CreateEventState {}

final class EventInitial extends CreateEventState {}

// ------------- Create Event States ------------- //

final class CreateEventLoadingState extends CreateEventState {}

final class CreateEventErrorState extends CreateEventState {
  final String error;

  CreateEventErrorState({required this.error});
}

final class CreateEventSuccessState extends CreateEventState {
  final String message;
  final bool isSuccess;

  CreateEventSuccessState({required this.message, required this.isSuccess});
}
