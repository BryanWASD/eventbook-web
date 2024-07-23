// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'join_event_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JoinEventRequestDto _$JoinEventRequestDtoFromJson(Map<String, dynamic> json) =>
    JoinEventRequestDto(
      eventId: (json['eventId'] as num).toInt(),
      userId: (json['userId'] as num).toInt(),
    );

Map<String, dynamic> _$JoinEventRequestDtoToJson(
        JoinEventRequestDto instance) =>
    <String, dynamic>{
      'eventId': instance.eventId,
      'userId': instance.userId,
    };
