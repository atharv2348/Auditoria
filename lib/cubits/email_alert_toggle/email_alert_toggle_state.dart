part of 'email_alert_toggle_cubit.dart';

@immutable
sealed class EmailAlertToggleState {}

final class EmailAlertToggleInitial extends EmailAlertToggleState {}

final class EmailALertToggleLoadingState extends EmailAlertToggleState {}

final class EmailALertToggleErrorState extends EmailAlertToggleState {
  final String error;

  EmailALertToggleErrorState({required this.error});
}

final class EmailALertToggleSuccessfulState extends EmailAlertToggleState {
  final bool isSuccess;
  final String message;

  EmailALertToggleSuccessfulState(
      {required this.isSuccess, required this.message});
}
