import 'package:json_annotation/json_annotation.dart';
part 'join_event_request_dto.g.dart';

@JsonSerializable()
class JoinEventRequestDto {
  JoinEventRequestDto({
    required this.eventId,
    required this.userId,
  });

  final int eventId;
  final int userId;

  factory JoinEventRequestDto.fromJson(Map<String, dynamic> json) =>
      _$JoinEventRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$JoinEventRequestDtoToJson(this);
}
