class FavoriteCity {
  final String name;
  final DateTime addedAt;

  FavoriteCity({
    required this.name,
    required this.addedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'addedAt': addedAt.toIso8601String(),
    };
  }

  factory FavoriteCity.fromJson(Map<String, dynamic> json) {
    return FavoriteCity(
      name: json['name'],
      addedAt: DateTime.parse(json['addedAt']),
    );
  }
}