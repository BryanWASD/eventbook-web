part of 'events_cubit.dart';

@immutable
abstract class EventsState {
  final List<EventResponseDto>? events;

  EventsState({this.events});
}

final class EventsInitial extends EventsState {}

final class EventsLoading extends EventsState {}

final class EventsSuccess extends EventsState {
  final List<EventResponseDto>? newEvents;

  EventsSuccess(this.newEvents) : super(events: newEvents);
}

final class EventsEmpty extends EventsState {}

final class EventsError extends EventsState {}
