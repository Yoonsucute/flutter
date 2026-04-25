import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../providers/weather_provider.dart';
import '../screens/search_screen.dart';
import '../screens/settings_screen.dart';
import '../widgets/current_weather_card.dart';
import '../widgets/forecast_list.dart';
import '../widgets/weather_detail_item.dart';
import '../widgets/loading_widget.dart';
import '../widgets/app_error_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _daLoad = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_daLoad) {
      _daLoad = true;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<WeatherProvider>().init();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<WeatherProvider>(
        builder: (context, provider, child) {
          if (provider.state == WeatherState.loading) {
            return const LoadingWidget();
          }

          if (provider.state == WeatherState.error) {
            return AppErrorWidget(
              message: provider.errorMessage,
              onRetry: () {
                provider.fetchWeatherByLocation();
              },
              onSearch: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SearchScreen(),
                  ),
                );
              },
            );
          }

          final weather = provider.currentWeather;

          if (weather == null) {
            return AppErrorWidget(
              message: 'Chưa có dữ liệu thời tiết',
              onRetry: () {
                provider.fetchWeatherByLocation();
              },
              onSearch: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SearchScreen(),
                  ),
                );
              },
            );
          }

          return RefreshIndicator(
            onRefresh: provider.refreshWeather,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverAppBar(
                  expandedHeight: 70,
                  floating: true,
                  pinned: true,
                  title: const Text('Weather App'),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SearchScreen(),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.settings),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SettingsScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      if (provider.isCachedData)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            provider.lastUpdateTime == null
                                ? 'Đang hiển thị dữ liệu đã lưu offline'
                                : 'Đang hiển thị dữ liệu offline - cập nhật lần cuối: ${DateFormat('HH:mm dd/MM/yyyy').format(provider.lastUpdateTime!)}',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      CurrentWeatherCard(weather: weather),
                      const SizedBox(height: 16),
                      ForecastList(forecasts: provider.forecast),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1.8,
                          children: [
                            WeatherDetailItem(
                              icon: Icons.water_drop,
                              title: 'Độ ẩm',
                              value: '${weather.humidity}%',
                            ),
                            WeatherDetailItem(
                              icon: Icons.air,
                              title: 'Gió',
                              value: '${weather.windSpeed.toStringAsFixed(1)} m/s',
                            ),
                            WeatherDetailItem(
                              icon: Icons.speed,
                              title: 'Áp suất',
                              value: '${weather.pressure} hPa',
                            ),
                            WeatherDetailItem(
                              icon: Icons.visibility,
                              title: 'Tầm nhìn',
                              value: '${(weather.visibility / 1000).toStringAsFixed(1)} km',
                            ),
                            WeatherDetailItem(
                              icon: Icons.cloud,
                              title: 'Mây',
                              value: '${weather.cloudiness}%',
                            ),
                            WeatherDetailItem(
                              icon: Icons.thermostat,
                              title: 'Cảm giác',
                              value: '${weather.feelsLike.round()}°C',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}