class ForecastModel {
  final List<ForecastItem> list;
  final String cityName;

  ForecastModel({required this.list, required this.cityName});

  factory ForecastModel.fromJson(Map<String, dynamic> json) {
    var list = (json['list'] as List)
        .map((item) => ForecastItem.fromJson(item))
        .toList();
    
    return ForecastModel(
      list: list,
      cityName: json['city']['name'] ?? '',
    );
  }
}

class ForecastItem {
  final DateTime dateTime;
  final double temperature;
  final String description;
  final String icon;
  final int humidity;
  final double windSpeed;

  ForecastItem({
    required this.dateTime,
    required this.temperature,
    required this.description,
    required this.icon,
    required this.humidity,
    required this.windSpeed,
  });

  factory ForecastItem.fromJson(Map<String, dynamic> json) {
    return ForecastItem(
      dateTime: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      temperature: (json['main']['temp'] ?? 0).toDouble(),
      description: json['weather'][0]['description'] ?? '',
      icon: json['weather'][0]['icon'] ?? '',
      humidity: json['main']['humidity'] ?? 0,
      windSpeed: (json['wind']['speed'] ?? 0).toDouble(),
    );
  }
}