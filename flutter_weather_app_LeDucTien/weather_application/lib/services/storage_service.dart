import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/weather_model.dart';

class StorageService {
  static const String _weatherKey = 'cached_weather';
  static const String _lastUpdateKey = 'last_update';
  static const String _favoriteCitiesKey = 'favorite_cities';
  static const String _recentSearchesKey = 'recent_searches';

  Future<void> saveWeatherData(WeatherModel weather) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      _weatherKey,
      json.encode(weather.toJson()),
    );

    await prefs.setInt(
      _lastUpdateKey,
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  Future<WeatherModel?> getCachedWeather() async {
    final prefs = await SharedPreferences.getInstance();

    final weatherJson = prefs.getString(_weatherKey);

    if (weatherJson == null) {
      return null;
    }

    try {
      return WeatherModel.fromJson(json.decode(weatherJson));
    } catch (_) {
      return null;
    }
  }

  Future<bool> isCacheValid() async {
    final prefs = await SharedPreferences.getInstance();

    final lastUpdate = prefs.getInt(_lastUpdateKey);

    if (lastUpdate == null) {
      return false;
    }

    final difference = DateTime.now().millisecondsSinceEpoch - lastUpdate;

    return difference < 30 * 60 * 1000;
  }

  Future<DateTime?> getLastUpdateTime() async {
    final prefs = await SharedPreferences.getInstance();

    final lastUpdate = prefs.getInt(_lastUpdateKey);

    if (lastUpdate == null) {
      return null;
    }

    return DateTime.fromMillisecondsSinceEpoch(lastUpdate);
  }

  Future<void> saveFavoriteCities(List<String> cities) async {
    final prefs = await SharedPreferences.getInstance();

    final limitedCities = cities.take(5).toList();

    await prefs.setStringList(_favoriteCitiesKey, limitedCities);
  }

  Future<List<String>> getFavoriteCities() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getStringList(_favoriteCitiesKey) ?? [];
  }

  Future<void> saveRecentSearches(List<String> cities) async {
    final prefs = await SharedPreferences.getInstance();

    final limitedCities = cities.take(10).toList();

    await prefs.setStringList(_recentSearchesKey, limitedCities);
  }

  Future<List<String>> getRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getStringList(_recentSearchesKey) ?? [];
  }
}