part of 'user_bloc.dart';

@immutable
sealed class UserState {}

final class UserInitial extends UserState {}

// ------------- Send OTP States ------------- //

class UserSendOtpLoadingState extends UserState {}

class UserSendOtpErrorState extends UserState {
  final String error;

  UserSendOtpErrorState({required this.error});
}

class UserSendOtpSucessState extends UserState {
  final String message;

  UserSendOtpSucessState({required this.message});
}

// ------------- Verify OTP States ------------- //

class UserVerifyOtpLoadingState extends UserState {}

class UserVerifyOtpErrorState extends UserState {
  final String error;

  UserVerifyOtpErrorState({required this.error});
}

class UserVerifyOtpSucessState extends UserState {
  final String? message;
  final bool? isNewUser;
  final bool? isSuccess;

  UserVerifyOtpSucessState(
      {required this.isSuccess,
      required this.message,
      required this.isNewUser});
}

// ------------- Create User States ------------- //

class UserCreateLoadingState extends UserState {}

class UserCreateErrorState extends UserState {
  final String error;

  UserCreateErrorState({required this.error});
}

class UserCreateSuccessState extends UserState {
  final String? message;
  final bool? isSuccess;

  UserCreateSuccessState({required this.isSuccess, required this.message});
}

