import 'dart:convert';
import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../models/weather_model.dart';
import '../models/forecast_model.dart';

class WeatherService {
  Future<WeatherModel> getCurrentWeatherByCity(String cityName) async {
    if (ApiConfig.apiKey.isEmpty) {
      throw Exception('Chưa cấu hình API key trong file .env');
    }

    final url = ApiConfig.buildUrl(
      ApiConfig.currentWeather,
      {
        'q': cityName,
      },
    );

    final response = await http.get(Uri.parse(url)).timeout(
      const Duration(seconds: 15),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return WeatherModel.fromJson(data);
    }

    if (response.statusCode == 404) {
      throw Exception('Không tìm thấy thành phố');
    }

    if (response.statusCode == 401) {
      throw Exception('API key không hợp lệ');
    }

    if (response.statusCode == 429) {
      throw Exception('API bị giới hạn lượt gọi, thử lại sau');
    }

    throw Exception('Không tải được dữ liệu thời tiết');
  }

  Future<WeatherModel> getCurrentWeatherByCoordinates(
    double latitude,
    double longitude,
  ) async {
    if (ApiConfig.apiKey.isEmpty) {
      throw Exception('Chưa cấu hình API key trong file .env');
    }

    final url = ApiConfig.buildUrl(
      ApiConfig.currentWeather,
      {
        'lat': latitude,
        'lon': longitude,
      },
    );

    final response = await http.get(Uri.parse(url)).timeout(
      const Duration(seconds: 15),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return WeatherModel.fromJson(data);
    }

    if (response.statusCode == 401) {
      throw Exception('API key không hợp lệ');
    }

    throw Exception('Không tải được thời tiết theo vị trí');
  }

  Future<List<ForecastModel>> getForecastByCity(String cityName) async {
    if (ApiConfig.apiKey.isEmpty) {
      throw Exception('Chưa cấu hình API key trong file .env');
    }

    final url = ApiConfig.buildUrl(
      ApiConfig.forecast,
      {
        'q': cityName,
      },
    );

    final response = await http.get(Uri.parse(url)).timeout(
      const Duration(seconds: 15),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List list = data['list'] ?? [];

      return list.map((item) => ForecastModel.fromJson(item)).toList();
    }

    if (response.statusCode == 404) {
      throw Exception('Không tìm thấy thành phố');
    }

    throw Exception('Không tải được dự báo thời tiết');
  }

  String getIconUrl(String iconCode) {
    return 'https://openweathermap.org/img/wn/$iconCode@2x.png';
  }
}