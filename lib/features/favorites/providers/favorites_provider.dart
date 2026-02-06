import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/favorite_city.dart';

class FavoritesProvider with ChangeNotifier {
  List<FavoriteCity> _favorites = [];

  List<FavoriteCity> get favorites => _favorites;

  FavoritesProvider() {
    loadFavorites();
  }

  // Load favorites from storage
  Future<void> loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? favoritesJson = prefs.getString('favorites');
      
      if (favoritesJson != null) {
        final List<dynamic> decoded = json.decode(favoritesJson);
        _favorites = decoded.map((item) => FavoriteCity.fromJson(item)).toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading favorites: $e');
    }
  }

  // Save favorites to storage
  Future<void> _saveFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String encoded = json.encode(
        _favorites.map((city) => city.toJson()).toList(),
      );
      await prefs.setString('favorites', encoded);
    } catch (e) {
      debugPrint('Error saving favorites: $e');
    }
  }

  // Add city to favorites
  Future<void> addFavorite(String cityName) async {
    if (!isFavorite(cityName)) {
      _favorites.add(FavoriteCity(
        name: cityName,
        addedAt: DateTime.now(),
      ));
      await _saveFavorites();
      notifyListeners();
    }
  }

  // Remove city from favorites
  Future<void> removeFavorite(String cityName) async {
    _favorites.removeWhere((city) => 
      city.name.toLowerCase() == cityName.toLowerCase()
    );
    await _saveFavorites();
    notifyListeners();
  }

  // Check if city is favorite
  bool isFavorite(String cityName) {
    return _favorites.any((city) => 
      city.name.toLowerCase() == cityName.toLowerCase()
    );
  }

  // Toggle favorite status
  Future<void> toggleFavorite(String cityName) async {
    if (isFavorite(cityName)) {
      await removeFavorite(cityName);
    } else {
      await addFavorite(cityName);
    }
  }
}