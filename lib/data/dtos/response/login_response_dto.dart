import 'package:json_annotation/json_annotation.dart';
part 'login_response_dto.g.dart';

@JsonSerializable()
class LoginResponseDto {
  LoginResponseDto({
    required this.userId,
    required this.token,
  });

  final int userId;
  final String token;

  factory LoginResponseDto.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseDtoToJson(this);
}
