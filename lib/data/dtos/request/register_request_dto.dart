import 'package:json_annotation/json_annotation.dart';
part 'register_request_dto.g.dart';

@JsonSerializable()
class RegisterRequestDto {
  RegisterRequestDto({
    required this.username,
    required this.email,
    required this.password,
  });

  final String username;
  final String email;
  final String password;

  factory RegisterRequestDto.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterRequestDtoToJson(this);
}
