import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/models/weather_model.dart';

class WeatherService {
  final Dio dio = Dio();
  final String apiKey =
      'e82038bcacd2552327676c7c09f96292'; // OpenWeatherMap API key

  Future<Weather> getWeather(String city) async {
    try {
      final response = await dio.get(
        'https://api.openweathermap.org/data/2.5/weather',
        queryParameters: {
          'q': city,
          'appid': apiKey,
          'units': 'metric',
          'lang': 'tr',
        },
      );

      final data = response.data;
      debugPrint('Request URL: ${response.realUri}');
      debugPrint('Response data: ${response.data}');
      return Weather(
        description: data['weather'][0]['description'],
        temp: data['main']['temp'],
        feelsLike: data['main']['feels_like'],
        city: data['name'],
      );
    } catch (e) {
      if (e is DioException) {
        debugPrint('Error Type: ${e.type}');
        debugPrint('Error Message: ${e.message}');
        debugPrint('Response Data: ${e.response?.data}');
      }
      throw Exception('Failed to load weather data: ${e.toString()}');
    }
  }
}
