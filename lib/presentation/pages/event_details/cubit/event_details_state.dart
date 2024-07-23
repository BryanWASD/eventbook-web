part of 'event_details_cubit.dart';

@immutable
sealed class EventDetailsState {}

final class EventDetailsInitial extends EventDetailsState {}

final class EventDetailsLoading extends EventDetailsState {}

final class EventDetailsSuccess extends EventDetailsState {}

final class EventDetailsEmpty extends EventDetailsState {}

final class EventDetailsError extends EventDetailsState {}
