import 'package:flutter/foundation.dart';
import '../../../core/services/weather_service.dart';
import '../../../core/services/location_service.dart';
import '../models/weather_model.dart';
import '../models/forecast_model.dart';

class WeatherProvider with ChangeNotifier {
  final WeatherService _weatherService = WeatherService();
  final LocationService _locationService = LocationService();

  WeatherModel? _currentWeather;
  ForecastModel? _forecast;
  bool _isLoading = false;
  String? _error;
  String _currentCity = 'London';
  List<String> _searchResults = [];

  WeatherModel? get currentWeather => _currentWeather;
  ForecastModel? get forecast => _forecast;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get currentCity => _currentCity;
  List<String> get searchResults => _searchResults;

  // Get weather by city name
  Future<void> getWeatherByCity(String city) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentWeather = await _weatherService.getCurrentWeather(city);
      _forecast = await _weatherService.getForecast(city);
      _currentCity = city;
      _error = null;
    } catch (e) {
      _error = 'Failed to load weather data. Please check city name.';
      debugPrint('Error: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  // Get weather by current location
  Future<void> getWeatherByLocation() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final position = await _locationService.getCurrentLocation();
      _currentWeather = await _weatherService.getCurrentWeatherByCoords(
        position.latitude,
        position.longitude,
      );
      
      final cityName = await _locationService.getCityFromCoordinates(
        position.latitude,
        position.longitude,
      );
      
      _currentCity = cityName;
      _forecast = await _weatherService.getForecast(_currentCity);
      _error = null;
    } catch (e) {
      _error = 'Failed to get location. Please enable location services.';
      debugPrint('Error: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  // Search cities
  Future<void> searchCities(String query) async {
    if (query.isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }

    try {
      _searchResults = await _weatherService.searchCities(query);
      notifyListeners();
    } catch (e) {
      debugPrint('Search error: $e');
    }
  }

  // Clear search
  void clearSearch() {
    _searchResults = [];
    notifyListeners();
  }

  // Refresh current weather
  Future<void> refresh() async {
    await getWeatherByCity(_currentCity);
  }
}