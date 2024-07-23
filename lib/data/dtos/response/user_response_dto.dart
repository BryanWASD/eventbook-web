import 'package:json_annotation/json_annotation.dart';

part 'user_response_dto.g.dart';

@JsonSerializable()
class UserResponseDto {
  int id;
  String username;
  String email;

  UserResponseDto({required this.id, required this.username, required this.email});

  factory UserResponseDto.fromJson(Map<String, dynamic> json) => _$UserResponseDtoFromJson(json);
  Map<String, dynamic> toJson() => _$UserResponseDtoToJson(this);
}