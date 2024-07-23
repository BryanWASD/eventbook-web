// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventRequestDto _$EventRequestDtoFromJson(Map<String, dynamic> json) =>
    EventRequestDto(
      name: json['name'] as String,
      date: json['date'] as String,
      time: json['time'] as String,
      description: json['description'] as String,
      special_guests: json['special_guests'] as String?,
      cost: json['cost'] as String?,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      location_name: json['location_name'] as String?,
      status: json['status'] as String,
      createdBy: (json['createdBy'] as num?)?.toInt(),
    );

Map<String, dynamic> _$EventRequestDtoToJson(EventRequestDto instance) =>
    <String, dynamic>{
      'name': instance.name,
      'date': instance.date,
      'time': instance.time,
      'description': instance.description,
      'special_guests': instance.special_guests,
      'cost': instance.cost,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'location_name': instance.location_name,
      'status': instance.status,
      'createdBy': instance.createdBy,
    };
