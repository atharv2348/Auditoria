import 'dart:async';

import 'package:auditoria/models/event_model.dart';
import 'package:auditoria/repositories/event_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'fetch_my_events_event.dart';
part 'fetch_my_events_state.dart';

class FetchMyEventsBloc extends Bloc<FetchMyEventsEvent, FetchMyEventsState> {
  FetchMyEventsBloc() : super(FetchMyEventsInitial()) {
    on<FetchMyEventsEvent>((event, emit) {});
    on<FetchEvents>(fetchEvents);
  }

  FutureOr<void> fetchEvents(
      FetchEvents event, Emitter<FetchMyEventsState> emit) async {
    emit(FetchMyEventsLoadingState());
    try {
      List<EventModel> userEvents = await EventRepo.getAllUserEvents();
      emit(FetchMyEventsSuccessState(userEvents: userEvents));
    } catch (e) {
      emit(FetchMyEventsErrorState(error: e.toString()));
    }
  }
}
