import 'package:auditoria/models/user_model.dart';
import 'package:auditoria/repositories/user_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'verify_token_state.dart';

class VerifyTokenCubit extends Cubit<VerifyTokenState> {
  VerifyTokenCubit() : super(VerifyTokenInitial());

  Future<void> verifyToken() async {
    String? token = await UserRepo.getUserTokenFromLocalStorage();

    // if token is absent in local storage, navigte to EmailPage
    if (token == null || token.isEmpty) {
      emit(NavigateToEmailPage());
      return;
    }

    // verify the token
    emit(VerifyTokenLoadingState());
    try {
      Map<String, dynamic> response = await UserRepo.verifyToken(token);
      if (!response['success']) {
        emit(NavigateToEmailPage());
      } else {
        await UserRepo.storeUserLocally(
            response['token'], UserModel.fromJson(response['data']));
        emit(VerifyTokenSuccessState(isSuccess: response['success']));
      }
    } catch (e) {
      emit(VerifyTokenErrorState(error: e.toString()));
    }
  }
}
