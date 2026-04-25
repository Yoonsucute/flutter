import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';

import '../models/forecast_model.dart';
import '../providers/settings_provider.dart';

class ForecastList extends StatelessWidget {
  final List<ForecastModel> forecasts;

  const ForecastList({
    super.key,
    required this.forecasts,
  });

  @override
  Widget build(BuildContext context) {
    if (forecasts.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Không có dữ liệu dự báo. Có thể bạn đang xem dữ liệu cache offline.',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    final hourly = forecasts.take(8).toList();
    final daily = _getDailyForecasts(forecasts);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _title('Dự báo theo giờ'),
        SizedBox(
          height: 145,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: hourly.length,
            itemBuilder: (context, index) {
              final item = hourly[index];
              return _HourlyItem(forecast: item);
            },
          ),
        ),
        const SizedBox(height: 12),
        _title('Dự báo 5 ngày'),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: daily.length,
          itemBuilder: (context, index) {
            final item = daily[index];
            return _DailyItem(forecast: item);
          },
        ),
      ],
    );
  }

  Widget _title(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 21,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  List<ForecastModel> _getDailyForecasts(List<ForecastModel> list) {
    final Map<String, ForecastModel> map = {};

    for (final item in list) {
      final key = DateFormat('yyyy-MM-dd').format(item.dateTime);

      if (!map.containsKey(key) && item.dateTime.hour >= 11) {
        map[key] = item;
      }
    }

    return map.values.take(5).toList();
  }
}

class _HourlyItem extends StatelessWidget {
  final ForecastModel forecast;

  const _HourlyItem({
    required this.forecast,
  });

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final temp = settings.convertTemperature(forecast.temperature);

    return Container(
      width: 95,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            DateFormat('HH:mm').format(forecast.dateTime),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          CachedNetworkImage(
            imageUrl:
                'https://openweathermap.org/img/wn/${forecast.icon}@2x.png',
            height: 50,
            errorWidget: (context, url, error) => const Icon(Icons.cloud),
          ),
          Text(
            '${temp.round()}${settings.temperatureUnit}',
            style: const TextStyle(fontSize: 18),
          ),
          Text(
            '${forecast.humidity}%',
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _DailyItem extends StatelessWidget {
  final ForecastModel forecast;

  const _DailyItem({
    required this.forecast,
  });

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    final tempMin = settings.convertTemperature(forecast.tempMin);
    final tempMax = settings.convertTemperature(forecast.tempMax);

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: ListTile(
        leading: CachedNetworkImage(
          imageUrl:
              'https://openweathermap.org/img/wn/${forecast.icon}@2x.png',
          width: 50,
          errorWidget: (context, url, error) => const Icon(Icons.cloud),
        ),
        title: Text(
          DateFormat('EEEE, dd/MM').format(forecast.dateTime),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(forecast.description),
        trailing: Text(
          '${tempMin.round()} / ${tempMax.round()}${settings.temperatureUnit}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}