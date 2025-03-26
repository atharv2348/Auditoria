part of 'user_bloc.dart';

@immutable
sealed class UserEvent {}

class UserSentOtpEvent extends UserEvent {
  final String email;

  UserSentOtpEvent({required this.email});
}

class UserVerifyOtpEvent extends UserEvent {
  final String email;
  final String otp;

  UserVerifyOtpEvent({required this.otp, required this.email});
}

class UserCreateEvent extends UserEvent {
  final UserModel user;

  UserCreateEvent({required this.user});
}

