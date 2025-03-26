part of 'get_user_details_cubit.dart';

@immutable
sealed class GetUserDetailsState {}

final class GetUserDetailsInitial extends GetUserDetailsState {}

// ------------- Get User Details (Local Storage) States ------------- //

class UserGetDetailsFromStorageLoadingState extends GetUserDetailsState {}

class UserGetDetailsFromStorageErrorState extends GetUserDetailsState {
  final String error;

  UserGetDetailsFromStorageErrorState({required this.error});
}

class UserGetDetailsFromStorageSuccessState extends GetUserDetailsState {
  final UserModel user;

  UserGetDetailsFromStorageSuccessState({required this.user});
}
