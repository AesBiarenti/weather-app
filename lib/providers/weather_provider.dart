import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/services/weather_services.dart';


// WeatherService provider
final weatherServiceProvider = Provider<WeatherService>((ref) {
  return WeatherService();
});

// Weather provider
final weatherProvider = FutureProvider.family<Weather, String>((ref, city) async {
  final weatherService = ref.read(weatherServiceProvider);
  return weatherService.getWeather(city);
});
