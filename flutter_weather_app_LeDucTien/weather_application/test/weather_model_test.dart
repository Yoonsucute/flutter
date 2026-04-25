import 'package:flutter_test/flutter_test.dart';
import '../lib/models/weather_model.dart';

void main() {
  group('WeatherModel Tests', () {
    test('Parse weather JSON correctly', () {
      final json = {
        'name': 'Ho Chi Minh City',
        'sys': {
          'country': 'VN',
          'sunrise': 1714000000,
          'sunset': 1714044000,
        },
        'main': {
          'temp': 25.0,
          'feels_like': 27.0,
          'humidity': 80,
          'pressure': 1012,
          'temp_min': 24.0,
          'temp_max': 30.0,
        },
        'wind': {
          'speed': 3.5,
        },
        'weather': [
          {
            'description': 'mây rải rác',
            'icon': '03d',
            'main': 'Clouds',
          }
        ],
        'dt': 1714000000,
        'visibility': 10000,
        'clouds': {
          'all': 40,
        },
      };

      final weather = WeatherModel.fromJson(json);

      expect(weather.cityName, 'Ho Chi Minh City');
      expect(weather.country, 'VN');
      expect(weather.temperature, 25.0);
      expect(weather.feelsLike, 27.0);
      expect(weather.humidity, 80);
      expect(weather.pressure, 1012);
      expect(weather.windSpeed, 3.5);
      expect(weather.description, 'mây rải rác');
      expect(weather.icon, '03d');
      expect(weather.mainCondition, 'Clouds');
      expect(weather.visibility, 10000);
      expect(weather.cloudiness, 40);
    });

    test('Convert WeatherModel to JSON correctly', () {
      final json = {
        'name': 'Ho Chi Minh City',
        'sys': {
          'country': 'VN',
          'sunrise': 1714000000,
          'sunset': 1714044000,
        },
        'main': {
          'temp': 25.0,
          'feels_like': 27.0,
          'humidity': 80,
          'pressure': 1012,
          'temp_min': 24.0,
          'temp_max': 30.0,
        },
        'wind': {
          'speed': 3.5,
        },
        'weather': [
          {
            'description': 'mây rải rác',
            'icon': '03d',
            'main': 'Clouds',
          }
        ],
        'dt': 1714000000,
        'visibility': 10000,
        'clouds': {
          'all': 40,
        },
      };

      final weather = WeatherModel.fromJson(json);
      final result = weather.toJson();

      expect(result['name'], 'Ho Chi Minh City');
      expect(result['sys']['country'], 'VN');
      expect(result['main']['temp'], 25.0);
      expect(result['main']['humidity'], 80);
      expect(result['wind']['speed'], 3.5);
      expect(result['weather'][0]['main'], 'Clouds');
    });
  });
}