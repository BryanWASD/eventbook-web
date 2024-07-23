import 'package:bloc/bloc.dart';
import 'package:eventsapp/data/dtos/request/join_event_request_dto.dart';
import 'package:eventsapp/data/source/api_data.dart';
import 'package:eventsapp/presentation/pages/add_events/widgets/join_dialog.dart';
import 'package:eventsapp/presentation/pages/event_details/widgets/succesfull_deleted_dialog.dart';
import 'package:eventsapp/presentation/pages/home/home.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

part 'event_details_state.dart';

class EventDetailsCubit extends Cubit<EventDetailsState> {
  final logger = Logger();
  final ApiClient client;
  EventDetailsCubit(this.client) : super(EventDetailsInitial());

  void deleteEventById(int eventId, BuildContext context) async {
    emit(EventDetailsLoading());
    try {
      await client.deleteEvent(eventId);
      logger.i('Evento eliminado con éxito');
      emit(EventDetailsSuccess());
      await SuccessfulDeletedDialog()
          .show(
        context: context,
        duration: const Duration(seconds: 2),
      )
          .then((value) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Home(),
          ),
        );
      });
    } catch (e) {
      logger.e('Error al eliminar el evento: $e');
      emit(EventDetailsError());
    }
  }

  void join(int eventId, int userId, BuildContext context) async {
    emit(EventDetailsLoading());
    try {
      final joinRequest = JoinEventRequestDto(
        eventId: eventId,
        userId: userId,
      );

      await client.join(joinRequest);

      logger.i('User joined event successfully: $joinRequest');

      emit(EventDetailsSuccess());
      await SuccessfulJoinDialog()
          .show(
        context: context,
        duration: const Duration(seconds: 2),
      )
          .then((value) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const Home()));
      });
    } catch (e) {
      logger.e('Error joining event: $e');
      emit(EventDetailsError());
    }
  }
}
