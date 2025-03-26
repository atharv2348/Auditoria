import 'dart:async';

import 'package:auditoria/models/event_model.dart';
import 'package:auditoria/repositories/event_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'fetch_booked_events_event.dart';
part 'fetch_booked_events_state.dart';

class FetchBookedEventsBloc
    extends Bloc<FetchBookedEventsEvent, FetchBookedEventsState> {
  FetchBookedEventsBloc() : super(FetchBookedEventsInitial()) {
    on<FetchBookedEventsEvent>((event, emit) {});
    on<FetchEvents>(fetchEvents);
  }

  FutureOr<void> fetchEvents(FetchBookedEventsEvent event,
      Emitter<FetchBookedEventsState> emit) async {
    emit(FetchBookedEventsLoadingState());
    try {
      List<EventModel> bookedEvents = await EventRepo.getBookedEvents();
      emit(FetchBookedEventsSuccessState(bookedEvents: bookedEvents));
    } catch (e) {
      emit(FetchBookedEventsErrorState(error: e.toString()));
    }
  }
}
