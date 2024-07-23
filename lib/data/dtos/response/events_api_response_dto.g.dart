// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'events_api_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventsApiResponseDto _$EventsApiResponseDtoFromJson(
        Map<String, dynamic> json) =>
    EventsApiResponseDto(
      events: (json['events'] as List<dynamic>)
          .map((e) => EventResponseDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$EventsApiResponseDtoToJson(
        EventsApiResponseDto instance) =>
    <String, dynamic>{
      'events': instance.events,
    };
