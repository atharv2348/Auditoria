import 'package:auditoria/repositories/user_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'update_user_access_state.dart';

class UpdateUserAccessCubit extends Cubit<UpdateUserAccessState> {
  UpdateUserAccessCubit() : super(UpdateUserAccessInitial());

  Future<void> updateUserAccess(
      {required String userId, required bool isApprove}) async {
    emit(UpdateUserAccessLoadingState());
    try {
      Map<String, dynamic> response = await UserRepo.updateUserAccess(
          userId: userId, hasBookingAccess: isApprove);
      emit(UpdateUserAccessSuccessState(
          isSuccess: response['success'], message: response['message']));
    } catch (e) {
      emit(UpdateUserAccessErrorState(error: e.toString()));
    }
  }
}
