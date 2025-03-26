import 'dart:async';

import 'package:auditoria/models/user_model.dart';
import 'package:auditoria/repositories/user_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'requested_access_event.dart';
part 'requested_access_state.dart';

class RequestedAccessBloc
    extends Bloc<RequestedAccessEvent, RequestedAccessState> {
  RequestedAccessBloc() : super(RequestedAccessInitial()) {
    on<RequestedAccessEvent>((event, emit) {});
    on<FetchRequestedAccessEvent>(fetchRequestedAccessEvent);
  }

  FutureOr<void> fetchRequestedAccessEvent(FetchRequestedAccessEvent event,
      Emitter<RequestedAccessState> emit) async {
    emit(FetchRequestedAccessLoadingState());
    try {
      List<UserModel> users = await UserRepo.getRequestedAccess();
      emit(FetchRequestedAccessSuccessState(requestedAccess: users));
    } catch (e) {
      emit(FetchRequestedAccessErrorState(error: e.toString()));
    }
  }
}
