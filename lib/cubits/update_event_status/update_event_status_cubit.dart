import 'package:auditoria/repositories/event_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'update_event_status_state.dart';

class UpdateEventStatusCubit extends Cubit<UpdateEventStatusState> {
  UpdateEventStatusCubit() : super(UpdateEventStatusInitial());

  Future<void> updateStatusOfRequested(
      {required String eventId,
      required bool isApprove,
      String? reason}) async {
    emit(UpdateStatusOfRequestedEventsLoadingState());
    try {
      Map<String, dynamic> response =
          await EventRepo.updateStatusOfRequestedEvent(
              eventId, isApprove, reason);
      emit(UpdateStatusOfRequestedEventsSuccessState(
          isSuccess: response['success'], message: response['message']));
    } catch (e) {
      emit(UpdateStatusOfRequestedEventsErrorState(error: e.toString()));
    }
  }
}
