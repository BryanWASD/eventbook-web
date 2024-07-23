import 'package:json_annotation/json_annotation.dart';

part 'event_request_dto.g.dart';

@JsonSerializable()
class EventRequestDto {
  final String name;
  final String date;
  final String time;
  final String description;
  @JsonKey(name: 'special_guests')
  final String? special_guests;
  final String? cost;
  final double latitude;
  final double longitude;
  @JsonKey(name: 'location_name')
  final String? location_name;
  final String status;
  final int? createdBy;

  EventRequestDto({
    required this.name,
    required this.date,
    required this.time,
    required this.description,
    this.special_guests,
    this.cost,
    required this.latitude,
    required this.longitude,
    this.location_name,
    required this.status,
    this.createdBy,
  });

  factory EventRequestDto.fromJson(Map<String, dynamic> json) =>
      _$EventRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$EventRequestDtoToJson(this);
}
