part of 'update_event_status_cubit.dart';

@immutable
sealed class UpdateEventStatusState {}

final class UpdateEventStatusInitial extends UpdateEventStatusState {}

// ------------- Update the Status of Requested Events States ------------- //

final class UpdateStatusOfRequestedEventsLoadingState
    extends UpdateEventStatusState {}

final class UpdateStatusOfRequestedEventsErrorState
    extends UpdateEventStatusState {
  final String error;

  UpdateStatusOfRequestedEventsErrorState({required this.error});
}

final class UpdateStatusOfRequestedEventsSuccessState
    extends UpdateEventStatusState {
  final bool isSuccess;
  final String message;

  UpdateStatusOfRequestedEventsSuccessState(
      {required this.isSuccess, required this.message});
}
