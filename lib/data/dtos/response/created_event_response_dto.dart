import 'package:json_annotation/json_annotation.dart';

part 'created_event_response_dto.g.dart';

@JsonSerializable()
class CreateEventResponseDto {
  final String message;

  CreateEventResponseDto({required this.message});

  factory CreateEventResponseDto.fromJson(Map<String, dynamic> json) =>
      _$CreateEventResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CreateEventResponseDtoToJson(this);
}
