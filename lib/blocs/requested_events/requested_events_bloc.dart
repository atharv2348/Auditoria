import 'dart:async';

import 'package:auditoria/models/event_model.dart';
import 'package:auditoria/repositories/event_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'requested_events_event.dart';
part 'requested_events_state.dart';

class RequestedEventBloc
    extends Bloc<RequestedEventsEvent, RequestedEventsState> {
  RequestedEventBloc() : super(RequestedEventsInitial()) {
    on<RequestedEventsEvent>((event, emit) {});
    on<FetchRequestedEvent>(fetchRequestedEvents);
  }

  FutureOr<void> fetchRequestedEvents(
      FetchRequestedEvent event, Emitter<RequestedEventsState> emit) async {
    emit(FetchRequestedEventsLoadingState());
    try {
      List<EventModel> bookedEvents = await EventRepo.getRequestedEvents();
      emit(FetchRequestedEventsSuccessState(requestedEvents: bookedEvents));
    } catch (e) {
      emit(FetchRequestedEventsErrorState(error: e.toString()));
    }
  }
}
