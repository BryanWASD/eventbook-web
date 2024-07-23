import 'package:bloc/bloc.dart';
import 'package:eventsapp/data/dtos/request/event_request_dto.dart';
import 'package:eventsapp/data/source/api_data.dart';
import 'package:eventsapp/presentation/pages/add_events/widgets/add_dialog.dart';
import 'package:eventsapp/presentation/pages/add_events/widgets/edit_dialog.dart';
import 'package:eventsapp/presentation/pages/home/home.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

part 'add_event_state.dart';

class AddEventCubit extends Cubit<AddEventState> {
  final logger = Logger();
  final ApiClient client;
  AddEventCubit(this.client) : super(AddEventInitial());

  void createEvent(
    String name,
    String date,
    String time,
    String description,
    String specialGuests,
    String cost,
    double latitude,
    double longitude,
    String locationName,
    String status,
    int createdBy,
    BuildContext context,
  ) async {
    emit(AddEventLoading());
    try {
      final request = EventRequestDto(
        name: name,
        location_name: locationName,
        date: date,
        time: time,
        description: description,
        special_guests: specialGuests,
        latitude: latitude,
        longitude: longitude,
        cost: cost,
        status: status,
        createdBy: createdBy,
      );

      logger.i(request.special_guests);

      await client.createEvent(request);

      logger.i('Event created successfully + $request');

      emit(AddEventSuccess());
      await SuccessfulCreatedDialog().show(
        context: context,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      logger.e(e);
      emit(AddEventError());
    }
  }

  void editEvent(
    int id,
    String name,
    String date,
    String time,
    String description,
    String specialGuests,
    String cost,
    double latitude,
    double longitude,
    String locationName,
    String status,
    BuildContext context,
  ) async {
    emit(AddEventLoading());
    try {
      final request = EventRequestDto(
        name: name,
        location_name: locationName,
        date: date,
        time: time,
        description: description,
        special_guests: specialGuests,
        latitude: latitude,
        longitude: longitude,
        cost: cost,
        status: status,
      );

      await client.updateEvent(id, request);
      logger.i('Event updated successfully + $request');
      emit(AddEventSuccess());
      await SuccessfulEditedDialog()
          .show(
        context: context,
        duration: const Duration(seconds: 2),
      )
          .then((value) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const Home()));
      });
    } catch (e) {
      logger.e(e);
      emit(AddEventError());
    }
  }
}
