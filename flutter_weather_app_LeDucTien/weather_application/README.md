# Flutter Weather App

## 1. Project Description

Flutter Weather App is a mobile weather application built with Flutter. The application uses OpenWeatherMap API to display real-time weather data, hourly forecast, and 5-day forecast. It also supports location-based weather, city search, offline cached data, favorite cities, pull-to-refresh, and temperature unit conversion.

This project was developed for Lab 4 - Weather Application with API Integration.

## 2. Features

### Core Features

- Display current weather information
- Show city name and country
- Show current temperature
- Show weather description and weather icon
- Show feels-like temperature
- Show humidity, wind speed, pressure, visibility, and cloudiness
- Display hourly weather forecast
- Display 5-day weather forecast
- Search weather by city name
- Detect weather by current location
- Handle location permission
- Save last weather data for offline support
- Show cached data when offline
- Pull-to-refresh weather data
- Dynamic weather background based on weather conditions
- Favorite cities management
- Recent search history
- Settings screen
- Temperature unit conversion between Celsius and Fahrenheit
- Loading state and error state handling

### Error Handling

The app handles common errors such as:

- Invalid city name
- Empty search input
- Special characters in search input
- No internet connection
- Invalid API key
- API timeout
- API rate limit exceeded with HTTP status code 429
- Location permission denied

## 3. Technologies Used

- Flutter
- Dart
- OpenWeatherMap API
- Provider for state management
- HTTP package for API requests
- Geolocator for location services
- Geocoding for reverse geocoding
- Shared Preferences for offline caching
- Flutter Dotenv for API key management
- Cached Network Image for weather icons
- Intl for date formatting

## 4. API Setup

This project uses OpenWeatherMap API.

### Step 1: Get API Key

Create a free account at OpenWeatherMap and get an API key.

### Step 2: Create `.env` file

Copy `.env.example` to `.env`.

```env

OPENWEATHER_API_KEY=your_actual_api_key_here
Step 3: Keep API Key Secure

Do not commit .env to GitHub.

The repository includes .env.example only:

OPENWEATHER_API_KEY=your_api_key_here

The .gitignore file includes:

.env
build/
.dart_tool/
5. How to Run the Project
Step 1: Clone the repository
git clone https://github.com/Yoonsucute/flutter.git
Step 2: Open the project folder
cd flutter_weather_app_LeDucTien/weather_application
Step 3: Install dependencies
flutter pub get
Step 4: Add API key

Create a .env file and add your OpenWeatherMap API key:

OPENWEATHER_API_KEY=your_actual_api_key_here
Step 5: Run the application
flutter run

# weather_application
Test the following scenarios:
1.	Network Conditions:
-App works with stable internet
<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/51d4aad2-500d-4a2c-88ba-588d74228b89" />
-	App handles slow internet gracefully
<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/ca0cd150-9202-432e-8d37-c52eeb4d1f5c" />
-	App works offline with cached data
<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/a3262d9e-5163-4ffe-965c-4a816d30e812" />
-	App recovers when connection restored
<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/102a5548-9c26-497b-9137-0ec669c9b74b" />

2.	Location Permissions:
-	Permission granted - fetches location weather
<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/5b011bf7-6644-4043-824e-c1abb1936676" />
-	Permission denied - shows manual search
<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/a81e6960-5bd0-47bb-a5f1-eded7469d615" />
-	Permission denied forever - clear instructions
<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/a81e6960-5bd0-47bb-a5f1-eded7469d615" />

3.	Search Functionality:
-	Valid city name returns weather
<img width="1219" height="1079" alt="image" src="https://github.com/user-attachments/assets/72ecddd7-e07f-428a-bea6-404cf71cb63d" />
-	Invalid city shows error message
<img width="1914" height="1079" alt="image" src="https://github.com/user-attachments/assets/43a32dad-0d47-43e7-980b-cca9ee6e0bb0" />
-	Empty search handled properly
<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/af547f22-e1f5-48d0-968c-7494631b83e5" />
-	Special characters handled
<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/fc67b024-ae4a-4ec2-95bb-7ed7fd44fe9f" />
4.	API Scenarios:
-	API responds successfully
<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/aa65917a-5607-4eda-8fe9-6af4d3b3c80e" />
-	API rate limit exceeded
<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/6ed488d1-eff7-485f-a754-db87cb7e6a9c" />
-	Invalid API key
<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/628e82d7-5c81-46cf-b21a-c19bac78dae2" />
-	API timeout
<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/9cbaba40-f4ea-4ee8-8406-5086a645891a" />
5.	UI Responsiveness:
-	Loading states display properly
<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/ca0cd150-9202-432e-8d37-c52eeb4d1f5c" />
-	Error states show helpful messages
<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/a81e6960-5bd0-47bb-a5f1-eded7469d615" />
-	Pull-to-refresh works
<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/edd01740-5733-41e4-96cc-4c05b42274f9" />
<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/51715350-7ac5-4703-9fce-6c4e588c7c3b" />
-	Dynamic weather backgrounds
<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/8889c62f-93bc-4580-820b-8a15283f8723" />
<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/69e8f1e4-32df-465f-9a16-eff7a85cf237" />



