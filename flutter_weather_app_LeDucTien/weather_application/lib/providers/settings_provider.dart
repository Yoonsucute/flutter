import 'package:flutter/material.dart';

class SettingsProvider extends ChangeNotifier {
  bool _isCelsius = true;
  bool _isDarkMode = false;

  bool get isCelsius => _isCelsius;
  bool get isDarkMode => _isDarkMode;

  String get temperatureUnit => _isCelsius ? '°C' : '°F';

  void toggleTemperatureUnit(bool value) {
    _isCelsius = value;
    notifyListeners();
  }

  void toggleDarkMode(bool value) {
    _isDarkMode = value;
    notifyListeners();
  }

  double convertTemperature(double celsius) {
    if (_isCelsius) {
      return celsius;
    }

    return celsius * 9 / 5 + 32;
  }
}