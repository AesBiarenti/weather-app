import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/providers/weather_provider.dart';

class WeatherPage extends ConsumerStatefulWidget {
  const WeatherPage({super.key});

  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends ConsumerState<WeatherPage> {
  final cityController = TextEditingController();
  String? city;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Weather App')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: cityController,
              decoration: const InputDecoration(
                labelText: 'City',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  city = cityController.text.trim();
                });
                if (city!.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a city name')),
                  );
                } else {
                  ref.refresh(weatherProvider(city!));
                }
              },
              child: const Text('Get Weather'),
            ),
            const SizedBox(height: 16),
            if (city != null)
              Consumer(
                builder: (context, ref, child) {
                  final weatherAsyncValue = ref.watch(weatherProvider(city!));

                  return weatherAsyncValue.when(
                    data: (weather) => WeatherInfo(weather: weather), // <--- This is your WeatherInfo widget
                    loading: () => const CircularProgressIndicator(),
                    error: (error, stack) => Text('Error: $error'),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

class WeatherInfo extends StatelessWidget {
  final Weather weather;

  const WeatherInfo({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('City: ${weather.city}', style: const TextStyle(fontSize: 24)),
        Text('Temperature: ${weather.temp}°C'),
        Text('Feels Like: ${weather.feelsLike}°C'),
        Text('Description: ${weather.description}'),
      ],
    );
  }
}
