import 'package:eventsapp/data/dtos/response/user_response_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'event_response_dto.g.dart';

@JsonSerializable()
class EventResponseDto {
  int id;
  String name;
  String date;
  String time;
  String description;
  @JsonKey(name: 'special_guests')
  String? specialGuests;
  String? cost;
  double latitude;
  double longitude;
  @JsonKey(name: 'location_name')
  String? locationName;
  String status;
  int createdBy;

  @JsonKey(name: "Users")
  List<UserResponseDto>? users;

  EventResponseDto({
    required this.id,
    required this.name,
    required this.date,
    required this.time,
    required this.description,
    this.specialGuests,
    this.cost,
    required this.latitude,
    required this.longitude,
    this.locationName,
    required this.status,
    required this.createdBy,
    this.users = const [],
  });

  factory EventResponseDto.fromJson(Map<String, dynamic> json) =>
      _$EventResponseDtoFromJson(json);
  Map<String, dynamic> toJson() => _$EventResponseDtoToJson(this);
}
