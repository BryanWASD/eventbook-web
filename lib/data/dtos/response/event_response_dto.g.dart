// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventResponseDto _$EventResponseDtoFromJson(Map<String, dynamic> json) =>
    EventResponseDto(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      date: json['date'] as String,
      time: json['time'] as String,
      description: json['description'] as String,
      specialGuests: json['special_guests'] as String?,
      cost: json['cost'] as String?,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      locationName: json['location_name'] as String?,
      status: json['status'] as String,
      createdBy: (json['createdBy'] as num).toInt(),
      users: (json['Users'] as List<dynamic>?)
              ?.map((e) => UserResponseDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$EventResponseDtoToJson(EventResponseDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'date': instance.date,
      'time': instance.time,
      'description': instance.description,
      'special_guests': instance.specialGuests,
      'cost': instance.cost,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'location_name': instance.locationName,
      'status': instance.status,
      'createdBy': instance.createdBy,
      'Users': instance.users,
    };
