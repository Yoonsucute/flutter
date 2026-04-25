import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/weather_provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();

  Future<void> _searchCity(String city) async {
    final cityName = city.trim();

    if (cityName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập tên thành phố'),
        ),
      );
      return;
    }

    await context.read<WeatherProvider>().fetchWeatherByCity(cityName);

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Tìm kiếm thành phố'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                TextField(
                  controller: _controller,
                  textInputAction: TextInputAction.search,
                  onSubmitted: _searchCity,
                  decoration: InputDecoration(
                    labelText: 'Nhập tên thành phố',
                    hintText: 'Ví dụ: Ho Chi Minh City, Hanoi, London',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () {
                        _searchCity(_controller.text);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                if (provider.favoriteCities.isNotEmpty)
                  _buildSectionTitle('Thành phố yêu thích'),
                if (provider.favoriteCities.isNotEmpty)
                  Wrap(
                    spacing: 8,
                    children: provider.favoriteCities.map((city) {
                      return ActionChip(
                        avatar: const Icon(Icons.star, size: 18),
                        label: Text(city),
                        onPressed: () {
                          _searchCity(city);
                        },
                      );
                    }).toList(),
                  ),
                const SizedBox(height: 20),
                if (provider.recentSearches.isNotEmpty)
                  _buildSectionTitle('Tìm kiếm gần đây'),
                Expanded(
                  child: ListView.builder(
                    itemCount: provider.recentSearches.length,
                    itemBuilder: (context, index) {
                      final city = provider.recentSearches[index];

                      return ListTile(
                        leading: const Icon(Icons.history),
                        title: Text(city),
                        trailing: IconButton(
                          icon: Icon(
                            provider.isFavorite(city)
                                ? Icons.star
                                : Icons.star_border,
                          ),
                          onPressed: () {
                            provider.toggleFavoriteCity(city);
                          },
                        ),
                        onTap: () {
                          _searchCity(city);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}