import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Iconlar için
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
      appBar: AppBar(
        title: const Text('Weather App',
            style: TextStyle(fontFamily: 'Montserrat')),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: cityController,
              decoration: InputDecoration(
                labelText: 'Şehir Adını Girin',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: const Icon(Icons.search, color: Colors.deepPurple),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                setState(() {
                  city = cityController.text.trim();
                });
                if (city!.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Lütfen bir şehir adı girin')),
                  );
                } else {
                  ref.refresh(weatherProvider(city!));
                }
              },
              child: const Text(
                'Hava Durumunu Getir',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 24),
            if (city != null)
              Consumer(
                builder: (context, ref, child) {
                  final weatherAsyncValue = ref.watch(weatherProvider(city!));

                  return weatherAsyncValue.when(
                    data: (weather) => WeatherInfo(
                        weather: weather), // Şık UI Kartında Gösterim
                    loading: () => const CircularProgressIndicator(),
                    error: (error, stack) =>
                        const Text('Hata: Şehir Bulunamadı'),
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
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: Colors.deepPurpleAccent.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              weather.city,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const FaIcon(FontAwesomeIcons.temperatureHigh,
                    size: 28, color: Colors.orange),
                const SizedBox(width: 10),
                Text(
                  '${weather.temp}°C',
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const FaIcon(FontAwesomeIcons.wind,
                    size: 28, color: Colors.lightBlue),
                const SizedBox(width: 10),
                Text(
                  'Hissedilen: ${weather.feelsLike}°C',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w400),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              weather.description.toUpperCase(),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                fontFamily: 'Montserrat',
                color: Colors.deepPurple,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
