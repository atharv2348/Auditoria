part of 'feedback_cubit.dart';

@immutable
sealed class FeedbackState {}

final class FeedbackInitial extends FeedbackState {}

// ------------- Feedback States ------------- //

class SendFeedbackLoadingState extends FeedbackState {}

class SendFeedbackErrorState extends FeedbackState {
  final String error;

  SendFeedbackErrorState({required this.error});
}

class SendFeedackSuccessState extends FeedbackState {
  final bool success;
  final String message;

  SendFeedackSuccessState({required this.success, required this.message});
}
