import 'package:auditoria/repositories/event_repo.dart';
import 'package:auditoria/repositories/user_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'email_alert_toggle_state.dart';

class EmailAlertToggleCubit extends Cubit<EmailAlertToggleState> {
  EmailAlertToggleCubit() : super(EmailAlertToggleInitial());

  Future<void> toggleEmailAlert(bool value) async {
    try {
      // call api and update in the backend
      final response = await EventRepo.toggleEmailAlert(value);
      // update the local data
      await UserRepo.updateHasBookingAccessLocally(value);
      emit(EmailALertToggleSuccessfulState(
          isSuccess: response['success'], message: response['message']));
    } catch (e) {
      emit(EmailALertToggleErrorState(error: e.toString()));
    }
  }
}
