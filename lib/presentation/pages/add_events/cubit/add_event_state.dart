part of 'add_event_cubit.dart';

@immutable
abstract class AddEventState {}

final class AddEventInitial extends AddEventState {}

final class AddEventLoading extends AddEventState {}

final class AddEventSuccess extends AddEventState {}

final class AddEventEmpty extends AddEventState {}

final class AddEventError extends AddEventState {}
