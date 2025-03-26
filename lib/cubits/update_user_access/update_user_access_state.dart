part of 'update_user_access_cubit.dart';

@immutable
sealed class UpdateUserAccessState {}

final class UpdateUserAccessInitial extends UpdateUserAccessState {}

// ------------- Update the Status of Requested Events States ------------- //

final class UpdateUserAccessLoadingState extends UpdateUserAccessState {}

final class UpdateUserAccessErrorState extends UpdateUserAccessState {
  final String error;

  UpdateUserAccessErrorState({required this.error});
}

final class UpdateUserAccessSuccessState extends UpdateUserAccessState {
  final bool isSuccess;
  final String message;

  UpdateUserAccessSuccessState({required this.isSuccess, required this.message});
}
