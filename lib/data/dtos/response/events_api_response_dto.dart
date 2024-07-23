import 'package:eventsapp/data/dtos/response/event_response_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'events_api_response_dto.g.dart';

@JsonSerializable()
class EventsApiResponseDto {
  final List<EventResponseDto> events;

  EventsApiResponseDto({required this.events});

  factory EventsApiResponseDto.fromJson(Map<String, dynamic> json) =>
      _$EventsApiResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$EventsApiResponseDtoToJson(this);
}
