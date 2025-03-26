part of 'request_booking_access_cubit.dart';

@immutable
sealed class RequestBookingAccessState {}

final class RequestBookingAccessInitial extends RequestBookingAccessState {}

// ------------- Request the Booking Access States ------------- //

final class RequestBookingAccessLoadingState
    extends RequestBookingAccessState {}

final class RequestBookingAccessErrorState extends RequestBookingAccessState {
  final String error;

  RequestBookingAccessErrorState({required this.error});
}

final class RequestBookingAccessSuccessState extends RequestBookingAccessState {
  final bool isSuccess;
  final String message;

  RequestBookingAccessSuccessState(
      {required this.isSuccess, required this.message});
}
