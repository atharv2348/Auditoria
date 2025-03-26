import 'package:auditoria/repositories/event_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'request_booking_access_state.dart';

class RequestBookingAccessCubit extends Cubit<RequestBookingAccessState> {
  RequestBookingAccessCubit() : super(RequestBookingAccessInitial());

  Future<void> requestBookingAccessEvent() async {
    emit(RequestBookingAccessLoadingState());
    try {
      Map<String, dynamic> response = await EventRepo.requestBookingAccess();
      emit(RequestBookingAccessSuccessState(
          isSuccess: response['success'], message: response['message']));
    } catch (e) {
      emit(RequestBookingAccessErrorState(error: e.toString()));
    }
  }
}
