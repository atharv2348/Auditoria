import 'package:auditoria/models/user_model.dart';
import 'package:auditoria/repositories/user_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'get_user_details_state.dart';

class GetUserDetailsCubit extends Cubit<GetUserDetailsState> {
  GetUserDetailsCubit() : super(GetUserDetailsInitial());

  Future<void> getUserDetailsFromLocalStorage() async {
    emit(UserGetDetailsFromStorageLoadingState());
    try {
      UserModel? user = await UserRepo.getUserDetailsFromLocalStorage();
      emit(UserGetDetailsFromStorageSuccessState(user: user!));
    } catch (e) {
      emit(UserGetDetailsFromStorageErrorState(error: e.toString()));
    }
  }
}
