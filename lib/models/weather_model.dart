import 'package:json_annotation/json_annotation.dart';

part 'weather_model.g.dart';

@JsonSerializable()
class Weather {
  final String description;
  final double temp;
  final double feelsLike;
  final String city;

  Weather({
    required this.description,
    required this.temp,
    required this.feelsLike,
    required this.city,
  });

  factory Weather.fromJson(Map<String, dynamic> json) =>
      _$WeatherFromJson(json);
  Map<String, dynamic> toJson() => _$WeatherToJson(this);
}
