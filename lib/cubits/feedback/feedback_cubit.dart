import 'package:auditoria/repositories/user_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'feedback_state.dart';

class FeedbackCubit extends Cubit<FeedbackState> {
  FeedbackCubit() : super(FeedbackInitial());

  Future<void> sendFeedback(
      {required String feedback, required int rating}) async {
    emit(SendFeedbackLoadingState());
    try {
      Map<String, dynamic> response =
          await UserRepo.sendFeedback(feedback: feedback, rating: rating);
      emit(SendFeedackSuccessState(
          success: response['success'], message: response['message']));
    } catch (e) {
      emit(SendFeedbackErrorState(error: e.toString()));
    }
  }
}
