import 'package:json_annotation/json_annotation.dart';

part 'api_response_dto.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class ApiResponseDto<T> {
  ApiResponseDto({this.data, this.message, this.meta});

  final T? data;
  final String? message;
  final dynamic meta;

  factory ApiResponseDto.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$ApiResponseDtoFromJson<T>(json, fromJsonT);

  Map<String, dynamic> toJson() => _$ApiResponseDtoToJson<T>(this, _dataToJson);

  static T _dataToJson<T>(T input) => input;
}
