import 'dart:async';

import 'package:auditoria/models/user_model.dart';
import 'package:auditoria/repositories/user_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserInitial()) {
    on<UserEvent>((event, emit) {});

    on<UserSentOtpEvent>(userSentOtpEvent);
    on<UserVerifyOtpEvent>(userVerifyOtpEvent);
    on<UserCreateEvent>(userCreateEvent);
  }

  FutureOr<void> userSentOtpEvent(
      UserSentOtpEvent event, Emitter<UserState> emit) async {
    String email = event.email;
    emit(UserSendOtpLoadingState());
    try {
      String message = await UserRepo.getOtp(email);
      emit(UserSendOtpSucessState(message: message));
    } catch (e) {
      emit(UserSendOtpErrorState(error: e.toString()));
    }
  }

  FutureOr<void> userVerifyOtpEvent(
      UserVerifyOtpEvent event, Emitter<UserState> emit) async {
    String email = event.email;
    String otp = event.otp;
    emit(UserVerifyOtpLoadingState());
    try {
      Map<String, dynamic> response = await UserRepo.verifyOtp(email, otp);

      if (response['success'] == true && response['isNewUser'] == false) {
        UserModel userModel = UserModel.fromJson(response['data']);
        await UserRepo.storeUserLocally(response['token'], userModel);
      }

      emit(UserVerifyOtpSucessState(
          message: response['message'],
          isNewUser: response['isNewUser'],
          isSuccess: response['success']));
    } catch (e) {
      emit(UserVerifyOtpErrorState(error: e.toString()));
    }
  }

  FutureOr<void> userCreateEvent(
      UserCreateEvent event, Emitter<UserState> emit) async {
    UserModel user = event.user;

    emit(UserCreateLoadingState());
    try {
      Map<String, dynamic> response = await UserRepo.createUser(user);

      // if user is created, store it locally
      if (response['success']) {
        UserModel userModel = UserModel.fromJson(response['data']);
        await UserRepo.storeUserLocally(response['token'], userModel);
      }

      emit(UserCreateSuccessState(
          message: response['message'], isSuccess: response['success']));
    } catch (e) {
      emit(UserCreateErrorState(error: e.toString()));
    }
  }

 
}
