import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import '../../features/weather/models/weather_model.dart';
import '../../features/weather/models/forecast_model.dart';

class WeatherService {
  // Get current weather by city name
  Future<WeatherModel> getCurrentWeather(String city) async {
    final url = Uri.parse(
      '${ApiConstants.baseUrl}${ApiConstants.currentWeather}'
      '?q=$city&appid=${ApiConstants.apiKey}&units=metric'
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return WeatherModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  // Get current weather by coordinates
  Future<WeatherModel> getCurrentWeatherByCoords(double lat, double lon) async {
    final url = Uri.parse(
      '${ApiConstants.baseUrl}${ApiConstants.currentWeather}'
      '?lat=$lat&lon=$lon&appid=${ApiConstants.apiKey}&units=metric'
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return WeatherModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  // Get 5-day forecast
  Future<ForecastModel> getForecast(String city) async {
    final url = Uri.parse(
      '${ApiConstants.baseUrl}${ApiConstants.forecast}'
      '?q=$city&appid=${ApiConstants.apiKey}&units=metric'
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return ForecastModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load forecast data');
    }
  }

  // Search cities (autocomplete)
  Future<List<String>> searchCities(String query) async {
    // OpenWeatherMap doesn't have city search, so we'll use a simple list
    final cities = [
      'London', 'New York', 'Tokyo', 'Paris', 'Sydney',
      'Dubai', 'Singapore', 'Mumbai', 'Toronto', 'Berlin',
      'Madrid', 'Rome', 'Moscow', 'Seoul', 'Bangkok',
      'Istanbul', 'Mexico City', 'Los Angeles', 'Chicago', 'Colombo'
    ];
    
    return cities
        .where((city) => city.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}