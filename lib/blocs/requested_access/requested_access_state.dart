part of 'requested_access_bloc.dart';

@immutable
sealed class RequestedAccessState {}

final class RequestedAccessInitial extends RequestedAccessState {}

// ------------- Fetch All Requested Events States ------------- //

final class FetchRequestedAccessLoadingState extends RequestedAccessState {}

final class FetchRequestedAccessErrorState extends RequestedAccessState {
  final String error;

  FetchRequestedAccessErrorState({required this.error});
}

final class FetchRequestedAccessSuccessState extends RequestedAccessState {
  final List<UserModel> requestedAccess;

  FetchRequestedAccessSuccessState({required this.requestedAccess});
}
