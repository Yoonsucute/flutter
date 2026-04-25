import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Cài đặt'),
          ),
          body: ListView(
            children: [
              SwitchListTile(
                title: const Text('Dùng độ C'),
                subtitle: const Text('Tắt để chuyển sang độ F'),
                value: settings.isCelsius,
                onChanged: settings.toggleTemperatureUnit,
                secondary: const Icon(Icons.thermostat),
              ),
              SwitchListTile(
                title: const Text('Chế độ tối'),
                subtitle: const Text('Bật/tắt giao diện tối'),
                value: settings.isDarkMode,
                onChanged: settings.toggleDarkMode,
                secondary: const Icon(Icons.dark_mode),
              ),
              const ListTile(
                leading: Icon(Icons.info),
                title: Text('Nguồn dữ liệu'),
                subtitle: Text('OpenWeatherMap API'),
              ),
            ],
          ),
        );
      },
    );
  }
}