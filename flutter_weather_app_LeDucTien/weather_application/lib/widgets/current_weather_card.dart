import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/weather_model.dart';
import '../providers/weather_provider.dart';
import '../providers/settings_provider.dart';

class CurrentWeatherCard extends StatelessWidget {
  final WeatherModel weather;

  const CurrentWeatherCard({
    super.key,
    required this.weather,
  });

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final provider = context.watch<WeatherProvider>();

    final temp = settings.convertTemperature(weather.temperature);
    final feelsLike = settings.convertTemperature(weather.feelsLike);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: _getWeatherGradient(weather.mainCondition),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.18),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '${weather.cityName}, ${weather.country}',
                  style: const TextStyle(
                    fontSize: 26,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  provider.toggleFavoriteCity(weather.cityName);
                },
                icon: Icon(
                  provider.isFavorite(weather.cityName)
                      ? Icons.star
                      : Icons.star_border,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            DateFormat('EEEE, dd/MM/yyyy HH:mm').format(weather.dateTime),
            style: const TextStyle(
              fontSize: 15,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 16),
          CachedNetworkImage(
            imageUrl:
                'https://openweathermap.org/img/wn/${weather.icon}@4x.png',
            height: 120,
            placeholder: (context, url) => const CircularProgressIndicator(
              color: Colors.white,
            ),
            errorWidget: (context, url, error) => const Icon(
              Icons.cloud,
              color: Colors.white,
              size: 90,
            ),
          ),
          Text(
            '${temp.round()}${settings.temperatureUnit}',
            style: const TextStyle(
              fontSize: 78,
              color: Colors.white,
              fontWeight: FontWeight.w300,
            ),
          ),
          Text(
            weather.description.toUpperCase(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Cảm giác như ${feelsLike.round()}${settings.temperatureUnit}',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Thấp nhất ${settings.convertTemperature(weather.tempMin).round()}${settings.temperatureUnit} / Cao nhất ${settings.convertTemperature(weather.tempMax).round()}${settings.temperatureUnit}',
            style: const TextStyle(
              fontSize: 15,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  LinearGradient _getWeatherGradient(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear':
        return const LinearGradient(
          colors: [
            Color(0xFFFDB813),
            Color(0xFF87CEEB),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );

      case 'rain':
      case 'drizzle':
      case 'thunderstorm':
        return const LinearGradient(
          colors: [
            Color(0xFF4A5568),
            Color(0xFF718096),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );

      case 'clouds':
        return const LinearGradient(
          colors: [
            Color(0xFFA0AEC0),
            Color(0xFFCBD5E0),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );

      case 'snow':
        return const LinearGradient(
          colors: [
            Color(0xFF74B9FF),
            Color(0xFFDFF9FB),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );

      default:
        return const LinearGradient(
          colors: [
            Color(0xFF667EEA),
            Color(0xFF764BA2),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }
  }
}