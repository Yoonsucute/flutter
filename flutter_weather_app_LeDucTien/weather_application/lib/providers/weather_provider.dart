import 'package:flutter/material.dart';

import '../models/weather_model.dart';
import '../models/forecast_model.dart';
import '../services/weather_service.dart';
import '../services/location_service.dart';
import '../services/storage_service.dart';

enum WeatherState {
  initial,
  loading,
  loaded,
  error,
}

class WeatherProvider extends ChangeNotifier {
  final WeatherService weatherService;
  final LocationService locationService;
  final StorageService storageService;

  WeatherProvider({
    required this.weatherService,
    required this.locationService,
    required this.storageService,
  });

  WeatherModel? _currentWeather;
  List<ForecastModel> _forecast = [];
  WeatherState _state = WeatherState.initial;
  String _errorMessage = '';
  bool _isCachedData = false;
  DateTime? _lastUpdateTime;

  List<String> _favoriteCities = [];
  List<String> _recentSearches = [];

  WeatherModel? get currentWeather => _currentWeather;
  List<ForecastModel> get forecast => _forecast;
  WeatherState get state => _state;
  String get errorMessage => _errorMessage;
  bool get isCachedData => _isCachedData;
  DateTime? get lastUpdateTime => _lastUpdateTime;
  List<String> get favoriteCities => _favoriteCities;
  List<String> get recentSearches => _recentSearches;

  Future<void> init() async {
    _favoriteCities = await storageService.getFavoriteCities();
    _recentSearches = await storageService.getRecentSearches();

    await fetchWeatherByLocation();
  }

  Future<void> fetchWeatherByCity(String cityName) async {
    final trimmedCity = cityName.trim();

    if (trimmedCity.isEmpty) {
      _state = WeatherState.error;
      _errorMessage = 'Vui lòng nhập tên thành phố';
      notifyListeners();
      return;
    }

    _state = WeatherState.loading;
    _errorMessage = '';
    _isCachedData = false;
    notifyListeners();

    try {
      final weather = await weatherService.getCurrentWeatherByCity(trimmedCity);
      final forecastData = await weatherService.getForecastByCity(trimmedCity);

      _currentWeather = weather;
      _forecast = forecastData;
      _state = WeatherState.loaded;
      _errorMessage = '';
      _isCachedData = false;
      _lastUpdateTime = DateTime.now();

      await storageService.saveWeatherData(weather);
      await _addRecentSearch(weather.cityName);
    }  catch (e) {
  _state = WeatherState.error;
  _errorMessage = e.toString().replaceAll('Exception: ', '');
  _isCachedData = false;
}

    notifyListeners();
  }

  Future<void> fetchWeatherByLocation() async {
    _state = WeatherState.loading;
    _errorMessage = '';
    _isCachedData = false;
    notifyListeners();

    try {
      final position = await locationService.getCurrentLocation();

      final weather = await weatherService.getCurrentWeatherByCoordinates(
        position.latitude,
        position.longitude,
      );

      final forecastData = await weatherService.getForecastByCity(
        weather.cityName,
      );

      _currentWeather = weather;
      _forecast = forecastData;
      _state = WeatherState.loaded;
      _errorMessage = '';
      _isCachedData = false;
      _lastUpdateTime = DateTime.now();

      await storageService.saveWeatherData(weather);
    } catch (e) {
      final cached = await storageService.getCachedWeather();

if (cached != null) {
  _currentWeather = cached;
  _forecast = [];
  _state = WeatherState.loaded;
  _isCachedData = true;
  _lastUpdateTime = await storageService.getLastUpdateTime();
  _errorMessage = '';
} else {
        _state = WeatherState.error;
        _errorMessage = e.toString().replaceAll('Exception: ', '');
      }
    }

    notifyListeners();
  }

  Future<void> loadCachedWeather() async {
    final cached = await storageService.getCachedWeather();

    if (cached != null) {
      _currentWeather = cached;
      _state = WeatherState.loaded;
      _isCachedData = true;
      _lastUpdateTime = await storageService.getLastUpdateTime();
    }
  }

  Future<void> refreshWeather() async {
    if (_currentWeather != null) {
      await fetchWeatherByCity(_currentWeather!.cityName);
    } else {
      await fetchWeatherByLocation();
    }
  }

  Future<void> _addRecentSearch(String cityName) async {
    _recentSearches.removeWhere(
      (city) => city.toLowerCase() == cityName.toLowerCase(),
    );

    _recentSearches.insert(0, cityName);

    if (_recentSearches.length > 10) {
      _recentSearches = _recentSearches.take(10).toList();
    }

    await storageService.saveRecentSearches(_recentSearches);
  }

  Future<void> toggleFavoriteCity(String cityName) async {
    final exists = _favoriteCities.any(
      (city) => city.toLowerCase() == cityName.toLowerCase(),
    );

    if (exists) {
      _favoriteCities.removeWhere(
        (city) => city.toLowerCase() == cityName.toLowerCase(),
      );
    } else {
      if (_favoriteCities.length >= 5) {
        _favoriteCities.removeLast();
      }

      _favoriteCities.insert(0, cityName);
    }

    await storageService.saveFavoriteCities(_favoriteCities);
    notifyListeners();
  }

  bool isFavorite(String cityName) {
    return _favoriteCities.any(
      (city) => city.toLowerCase() == cityName.toLowerCase(),
    );
  }
}