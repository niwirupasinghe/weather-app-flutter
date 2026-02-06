# 🌤️ Weather App - Flutter Mobile Application

[

![Flutter](https://img.shields.io/badge/Flutter-3.38.3-02569B?logo=flutter)

](https://flutter.dev)
[

![Dart](https://img.shields.io/badge/Dart-3.10.1-0175C2?logo=dart)

](https://dart.dev)
[

![OpenWeatherMap](https://img.shields.io/badge/API-OpenWeatherMap-orange)

](https://openweathermap.org)

A modern, feature-rich weather application built with Flutter, integrating OpenWeatherMap API to provide real-time weather information, forecasts, and location-based services.

## 📱 Features

### Core Features (7)

1. **🌍 Current Weather Display**
   - Real-time weather data for any city worldwide
   - Temperature, humidity, wind speed, pressure, visibility
   - Sunrise and sunset times
   - Weather description with icons

2. **📍 Location-Based Weather**
   - Automatic location detection using GPS
   - Get weather for current position instantly
   - Geocoding for city name from coordinates

3. **📅 5-Day Weather Forecast**
   - Detailed hourly forecast for 5 days
   - Interactive temperature trend chart
   - Expandable daily view with 3-hour intervals
   - Visual weather icons for each period

4. **🔍 Smart City Search**
   - Search cities with autocomplete
   - Popular cities quick access
   - Country flags and location indicators
   - Fast navigation to searched cities

5. **⭐ Favorite Cities Management**
   - Save unlimited favorite locations
   - Quick access to saved cities
   - Remove favorites with confirmation
   - Persistent storage across sessions

6. **🌓 Dark/Light Theme**
   - Smooth theme switching
   - Material Design 3 implementation
   - Persistent theme preference
   - Eye-friendly dark mode

7. **📊 Data Visualization**
   - Temperature trend line chart
   - 24-hour forecast visualization
   - Interactive chart with tooltips
   - Responsive design for all screen sizes

## 🏗️ Architecture

### Design Pattern
- **MVVM (Model-View-ViewModel)** architecture
- Feature-based folder structure
- Separation of concerns (UI, Business Logic, Data)

### State Management
- **Provider** for reactive state management
- ChangeNotifier for state updates
- Consumer widgets for UI rebuilds

### Project Structure
lib/
├── core/
│   ├── constants/
│   │   └── api_constants.dart          # API configuration
│   ├── services/
│   │   ├── weather_service.dart        # API integration
│   │   └── location_service.dart       # GPS services
│   └── theme/
│       └── app_theme.dart              # Theme configuration
├── features/
│   ├── weather/
│   │   ├── models/
│   │   │   ├── weather_model.dart      # Weather data model
│   │   │   └── forecast_model.dart     # Forecast data model
│   │   ├── providers/
│   │   │   ├── weather_provider.dart   # Weather state management
│   │   │   └── theme_provider.dart     # Theme state management
│   │   ├── screens/
│   │   │   ├── splash_screen.dart      # Animated splash
│   │   │   ├── home_screen.dart        # Main weather display
│   │   │   ├── search_screen.dart      # City search
│   │   │   ├── forecast_screen.dart    # 5-day forecast
│   │   │   └── settings_screen.dart    # App settings
│   │   └── widgets/
│   └── favorites/
│       ├── models/
│       │   └── favorite_city.dart      # Favorite model
│       ├── providers/
│       │   └── favorites_provider.dart # Favorites state
│       └── screens/
│           └── favorites_screen.dart   # Favorites list
└── main.dart                           # App entry point
## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.38.3 or higher
- Dart SDK 3.10.1 or higher
- Android Studio / VS Code
- OpenWeatherMap API Key

### Installation Steps

1. **Clone the repository**
```bash
git clone https://github.com/YOUR_USERNAME/weather-app-flutter.git
cd weather-app-flutter
