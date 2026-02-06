class ApiConstants {
  // REPLACE WITH YOUR API KEY
  static const String apiKey = 'YOUR_API_KEY_HERE';
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5';
  
  // Endpoints
  static const String currentWeather = '/weather';
  static const String forecast = '/forecast';
  static const String airPollution = '/air_pollution';
  
  // Icon URL
  static String iconUrl(String icon) => 
      'https://openweathermap.org/img/wn/$icon@2x.png';
}