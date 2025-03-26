import 'dart:async';

import 'package:auditoria/models/event_model.dart';
import 'package:auditoria/repositories/event_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'create_event_event.dart';
part 'create_event_state.dart';

class CreateEventBloc extends Bloc<EventEvent, CreateEventState> {
  CreateEventBloc() : super(EventInitial()) {
    on<EventEvent>((event, emit) {});
    on<CreateEventEvent>(createEventEvent);
  }

  FutureOr<void> createEventEvent(
      CreateEventEvent event, Emitter<CreateEventState> emit) async {
    EventModel eventModel = event.event;
    emit(CreateEventLoadingState());
    try {
      Map<String, dynamic> response =
          await EventRepo.sendEventRequest(eventModel);

      emit(CreateEventSuccessState(
          message: response['message'], isSuccess: response['success']));
    } catch (e) {
      emit(CreateEventErrorState(error: e.toString()));
    }
  }
}
