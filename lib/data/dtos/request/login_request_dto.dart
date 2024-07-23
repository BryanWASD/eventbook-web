import 'package:json_annotation/json_annotation.dart';
part 'login_request_dto.g.dart';

@JsonSerializable()
class LoginRequestDto {
  LoginRequestDto({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;

  factory LoginRequestDto.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$LoginRequestDtoToJson(this);
}
