import 'dart:async';

import 'package:auditoria/models/event_model.dart';
import 'package:auditoria/repositories/event_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'fetch_upcoming_events_event.dart';
part 'fetch_upcoming_events_state.dart';

class FetchUpcomingEventsBloc
    extends Bloc<FetchUpcomingEventsEvent, FetchUpcomingEventsState> {
  FetchUpcomingEventsBloc() : super(FetchUpcomingEventsInitial()) {
    on<FetchUpcomingEventsEvent>((event, emit) {});
    on<FetchEvents>(fetchEvents);
  }

  FutureOr<void> fetchEvents(
      FetchEvents event, Emitter<FetchUpcomingEventsState> emit) async {
    emit(FetchUpcomingEventsLoadingState());
    try {
      List<EventModel> userEvents = await EventRepo.getUpcomingEvents();
      emit(FetchUpcomingEventsSuccessState(upcomingEvents: userEvents));
    } catch (e) {
      emit(FetchUpcomingEventsErrorState(error: e.toString()));
    }
  }
}
