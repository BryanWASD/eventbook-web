import 'package:dio/dio.dart';
import 'package:eventsapp/data/dtos/request/event_request_dto.dart';
import 'package:eventsapp/data/dtos/request/join_event_request_dto.dart';
import 'package:eventsapp/data/dtos/request/login_request_dto.dart';
import 'package:eventsapp/data/dtos/request/register_request_dto.dart';
import 'package:eventsapp/data/dtos/response/created_event_response_dto.dart';
import 'package:eventsapp/data/dtos/response/events_api_response_dto.dart';
import 'package:eventsapp/data/dtos/response/login_response_dto.dart';
import 'package:retrofit/http.dart';
import 'package:retrofit/retrofit.dart';

part 'api_data.g.dart';

@RestApi(baseUrl: "http://localhost:3000/api")
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  @GET("/events/all")
  Future<EventsApiResponseDto> getAllEvents();

  @POST("/users/login")
  Future<LoginResponseDto> login(
    @Body() LoginRequestDto login,
  );

  @POST("/users/register")
  Future<LoginResponseDto> register(
    @Body() RegisterRequestDto register,
  );

  @POST("/events/create")
  Future<CreateEventResponseDto> createEvent(
    @Body() EventRequestDto event,
  );

  @POST("/events/register")
  Future<void> join(
    @Body() JoinEventRequestDto join,
  );

  @DELETE("/events/delete/{id}")
  Future<void> deleteEvent(@Path("id") int eventId);

  @PUT("/events/update/{id}")
  Future<void> updateEvent(
    @Path("id") int eventId,
    @Body() EventRequestDto event,
  );
}
