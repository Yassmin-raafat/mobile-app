# Bite Bright - Meal Tracking App

A beautiful Flutter mobile application for tracking meals using the 80/20 rule (80% nourishing, 20% flexible meals).

##  Getting Started

### Prerequisites

Before running this app, make sure you have:

1. **Flutter SDK** installed (version 3.7.0 or higher)
   - Download from: https://docs.flutter.dev/get-started/install
   - Verify installation: `flutter --version`

2. **Development Environment** set up:
   - **For Android**: Android Studio with Android SDK
   - **For iOS**: Xcode (macOS only)
   - **For Web**: Chrome browser
   - **For Windows**: Visual Studio with C++ build tools

3. **Device/Emulator**:
   - Android Emulator or physical Android device
   - iOS Simulator or physical iOS device (macOS only)
   - Or run on web/desktop

### Installation Steps

1. **Clone or navigate to the project directory**
   ```bash
   cd "d:\Downloads\projects\app project\mobile-app"
   ```

2. **Get Flutter dependencies**
   ```bash
   flutter pub get
   ```
   This will install all required packages listed in `pubspec.yaml`:
   - `provider` - State management
   - `http` - API calls
   - `shared_preferences` - Local storage
   - `flutter_local_notifications` - Notifications

3. **Verify Flutter setup**
   ```bash
   flutter doctor
   ```
   Make sure all required components show a checkmark ✓

### Running the App

#### Option 1: Run on Android
```bash
# List available devices
flutter devices

# Run on Android emulator/device
flutter run
```

#### Option 2: Run on iOS (macOS only)
```bash
# Run on iOS simulator/device
flutter run
```

#### Option 3: Run on Web
```bash
flutter run -d chrome
```

#### Option 4: Run on Windows
```bash
flutter run -d windows
```

#### Option 5: Run on Specific Device
```bash
# List all available devices
flutter devices

# Run on a specific device (use device ID from flutter devices)
flutter run -d <device-id>
```

### Common Commands

```bash
# Clean build files
flutter clean

# Get dependencies again
flutter pub get

# Check for issues
flutter analyze

# Run tests
flutter test

# Build APK (Android)
flutter build apk

# Build iOS app
flutter build ios
```

### Troubleshooting

#### Issue: "No devices found"
- **Solution**: Start an emulator/simulator or connect a physical device
  - Android: Open Android Studio → AVD Manager → Start emulator
  - iOS: Open Xcode → Window → Devices and Simulators → Start simulator

#### Issue: "Pub get failed"
- **Solution**: 
  ```bash
  flutter clean
  flutter pub get
  ```

#### Issue: "SDK version mismatch"
- **Solution**: Update Flutter SDK
  ```bash
  flutter upgrade
  ```

#### Issue: "Build failed"
- **Solution**: 
  ```bash
  flutter clean
  flutter pub get
  flutter run
  ```

### Project Structure

```
lib/
├── main.dart                 # App entry point & navigation
├── models/
│   └── meal.dart            # Meal data model
├── screens/
│   ├── home_screen.dart     # Home dashboard
│   ├── tracker_screen.dart  # Log meals
│   ├── progress_screen.dart # View progress
│   └── profile_screen.dart  # User profile
├── providers/
│   └── meal_provider.dart   # State management
├── data/
│   └── meal_repository.dart # Data persistence
└── services/
    └── notification_service.dart # Local notifications
```

### Features

-  Modern, gradient-based UI design
-  80/20 meal tracking (Nourishing vs Flexible)
-  Progress visualization with charts
-  Local data persistence
-  Meal logging notifications
-  Achievement system
-  Responsive design

### Dependencies

- `provider: ^6.1.2` - State management
- `http: ^1.2.0` - HTTP requests for API
- `shared_preferences: ^2.2.2` - Local storage
- `flutter_local_notifications: ^17.1.2` - Notifications

### Notes

- The app uses an external API (adviceslip.com) for daily wellness tips
- Data is stored locally on the device
- Notifications require proper platform setup (Android/iOS permissions)

---

**Happy Coding! 🎉**

