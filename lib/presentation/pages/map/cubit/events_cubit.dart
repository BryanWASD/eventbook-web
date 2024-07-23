import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:eventsapp/data/dtos/response/event_response_dto.dart';
import 'package:eventsapp/data/dtos/response/events_api_response_dto.dart'; // Use EventsApiResponseDto
import 'package:eventsapp/data/source/api_data.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';

part 'events_state.dart';

class EventsCubit extends Cubit<EventsState> {
  final logger = Logger();
  EventsCubit() : super(EventsInitial());

  Future<void> getAllEvents() async {
    emit(EventsLoading());
    try {
      final dio = Dio();
      // dio.interceptors.add(LogInterceptor(responseBody: true));
      final client = ApiClient(dio);

      final EventsApiResponseDto response = await client.getAllEvents();

      // logger.i("Response data type: ${response.runtimeType}");
      // logger.i("Events list type: ${response.events.runtimeType}");
      // logger.i("First event: ${response.events.length}");

      final List<EventResponseDto> events = response.events;
      // logger.i("data: ${events[0].name}");

      if (events.isNotEmpty) {
        emit(EventsSuccess(events));
      } else {
        emit(EventsEmpty());
      }
    } on DioException catch (e) {
      logger.e(
          'DioError: ${e.response?.statusCode} - ${e.response?.statusMessage}');
      if (e.response == null) {
        emit(EventsError());
      } else {
        emit(EventsError());
      }
    } catch (e, stacktrace) {
      logger.e(
        'Other Error: $e + $stacktrace',
      );
      emit(EventsError());
    }
  }
}
