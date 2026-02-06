import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../providers/weather_provider.dart';
import '../providers/theme_provider.dart';
import '../../favorites/providers/favorites_provider.dart';
import '../../../core/constants/api_constants.dart';
import 'search_screen.dart';
import 'forecast_screen.dart';
import '../../favorites/screens/favorites_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WeatherProvider>().getWeatherByCity('London');
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      const WeatherHomeContent(),
      const ForecastScreen(),
      const FavoritesScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Forecast'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}

class WeatherHomeContent extends StatelessWidget {
  const WeatherHomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherProvider>(
      builder: (context, provider, child) {
        return RefreshIndicator(
          onRefresh: () => provider.refresh(),
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 120,
                floating: false,
                pinned: true,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    provider.currentCity,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SearchScreen()),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.my_location),
                    onPressed: () => provider.getWeatherByLocation(),
                  ),
                ],
              ),
              
              if (provider.isLoading)
                const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (provider.error != null)
                SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 64, color: Colors.red),
                        const SizedBox(height: 16),
                        Text(provider.error!),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => provider.refresh(),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                )
              else if (provider.currentWeather != null)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildMainWeatherCard(context, provider),
                        const SizedBox(height: 16),
                        _buildDetailsGrid(context, provider),
                        const SizedBox(height: 16),
                        _buildSunriseSunset(context, provider),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMainWeatherCard(BuildContext context, WeatherProvider provider) {
    final weather = provider.currentWeather!;
    final favProvider = context.watch<FavoritesProvider>();

    return Card(
      elevation: 8,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade400,
              Colors.blue.shade700,
            ],
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('EEEE, MMM d').format(DateTime.now()),
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                ),
                IconButton(
                  icon: Icon(
                    favProvider.isFavorite(weather.cityName)
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: Colors.white,
                  ),
                  onPressed: () => favProvider.toggleFavorite(weather.cityName),
                ),
              ],
            ),
            const SizedBox(height: 16),
            CachedNetworkImage(
              imageUrl: ApiConstants.iconUrl(weather.icon),
              width: 120,
              height: 120,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
            Text(
              '${weather.temperature.round()}°C',
              style: const TextStyle(
                fontSize: 64,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              weather.description.toUpperCase(),
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Feels like ${weather.feelsLike.round()}°C',
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsGrid(BuildContext context, WeatherProvider provider) {
    final weather = provider.currentWeather!;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        _buildDetailCard(
          context,
          'Humidity',
          '${weather.humidity}%',
          Icons.water_drop,
          Colors.blue,
        ),
        _buildDetailCard(
          context,
          'Wind Speed',
          '${weather.windSpeed} m/s',
          Icons.air,
          Colors.teal,
        ),
        _buildDetailCard(
          context,
          'Pressure',
          '${weather.pressure} hPa',
          Icons.speed,
          Colors.orange,
        ),
        _buildDetailCard(
          context,
          'Visibility',
          '${(weather.visibility / 1000).toStringAsFixed(1)} km',
          Icons.visibility,
          Colors.purple,
        ),
      ],
    );
  }

  Widget _buildDetailCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSunriseSunset(BuildContext context, WeatherProvider provider) {
    final weather = provider.currentWeather!;
    final sunrise = DateTime.fromMillisecondsSinceEpoch(weather.sunrise * 1000);
    final sunset = DateTime.fromMillisecondsSinceEpoch(weather.sunset * 1000);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                const Icon(Icons.wb_sunny, color: Colors.orange, size: 32),
                const SizedBox(height: 8),
                const Text('Sunrise', style: TextStyle(color: Colors.grey)),
                Text(
                  DateFormat('HH:mm').format(sunrise),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Column(
              children: [
                const Icon(Icons.nightlight, color: Colors.indigo, size: 32),
                const SizedBox(height: 8),
                const Text('Sunset', style: TextStyle(color: Colors.grey)),
                Text(
                  DateFormat('HH:mm').format(sunset),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}