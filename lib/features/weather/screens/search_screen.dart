import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search City'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Enter city name...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          context.read<WeatherProvider>().clearSearch();
                          setState(() {});
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
              ),
              onChanged: (value) {
                context.read<WeatherProvider>().searchCities(value);
                setState(() {});
              },
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  context.read<WeatherProvider>().getWeatherByCity(value);
                  Navigator.pop(context);
                }
              },
            ),
          ),
          Expanded(
            child: Consumer<WeatherProvider>(
              builder: (context, provider, child) {
                if (_searchController.text.isEmpty) {
                  return _buildPopularCities(context);
                }

                if (provider.searchResults.isEmpty) {
                  return const Center(
                    child: Text('No cities found'),
                  );
                }

                return ListView.builder(
                  itemCount: provider.searchResults.length,
                  itemBuilder: (context, index) {
                    final city = provider.searchResults[index];
                    return ListTile(
                      leading: const Icon(Icons.location_city),
                      title: Text(city),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        provider.getWeatherByCity(city);
                        Navigator.pop(context);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPopularCities(BuildContext context) {
    final popularCities = [
      {'name': 'London', 'country': 'United Kingdom', 'icon': '🇬🇧'},
      {'name': 'New York', 'country': 'United States', 'icon': '🇺🇸'},
      {'name': 'Tokyo', 'country': 'Japan', 'icon': '🇯🇵'},
      {'name': 'Paris', 'country': 'France', 'icon': '🇫🇷'},
      {'name': 'Dubai', 'country': 'UAE', 'icon': '🇦🇪'},
      {'name': 'Singapore', 'country': 'Singapore', 'icon': '🇸🇬'},
      {'name': 'Sydney', 'country': 'Australia', 'icon': '🇦🇺'},
      {'name': 'Mumbai', 'country': 'India', 'icon': '🇮🇳'},
      {'name': 'Colombo', 'country': 'Sri Lanka', 'icon': '🇱🇰'},
      {'name': 'Toronto', 'country': 'Canada', 'icon': '🇨🇦'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Popular Cities',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: popularCities.length,
            itemBuilder: (context, index) {
              final city = popularCities[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: ListTile(
                  leading: Text(
                    city['icon']!,
                    style: const TextStyle(fontSize: 32),
                  ),
                  title: Text(
                    city['name']!,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(city['country']!),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    context.read<WeatherProvider>().getWeatherByCity(city['name']!);
                    Navigator.pop(context);
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}