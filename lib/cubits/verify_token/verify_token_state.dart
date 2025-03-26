part of 'verify_token_cubit.dart';

@immutable
sealed class VerifyTokenState {}

final class VerifyTokenInitial extends VerifyTokenState {}

final class VerifyTokenLoadingState extends VerifyTokenState {}

final class VerifyTokenErrorState extends VerifyTokenState {
  final String error;

  VerifyTokenErrorState({required this.error});
}

final class VerifyTokenSuccessState extends VerifyTokenState {
  final bool isSuccess;
  VerifyTokenSuccessState({required this.isSuccess});
}

final class NavigateToEmailPage extends VerifyTokenState {}
