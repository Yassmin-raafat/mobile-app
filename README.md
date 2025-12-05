# Bite Bright - Meal Tracking App

A beautiful Flutter mobile application for tracking meals using the 80/20 rule (80% nourishing, 20% flexible meals).

##  Getting Started
[demo video phase2 ](https://drive.google.com/file/d/1b1yj3N9COOBB5abGwB-uP6zeMQGUSfb-/view?usp=sharing)


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


---




