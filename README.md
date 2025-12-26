# Animates App

A beautiful Flutter application showcasing smooth animations and interactive transitions. The app features an engaging onboarding screen with swipe gestures and a dynamic home screen with activity tracking.


## Features

✨ **Smooth Animations**

- Onboarding screen with entrance animations
- Interactive swipe-up gesture to navigate
- Color transition animations during swipe
- Staggered animations on home screen
- Slide transitions between screens

🎨 **Beautiful UI Design**

- Gradient backgrounds
- Decorative circular elements
- Yellow accent color scheme
- Clean, modern layout

📱 **Two Main Screens**

1. Onboarding Screen - "Ready to Start?"
2. Home Screen - User dashboard with activity tracking

## Prerequisites

Before you begin, ensure you have the following installed:

- **Flutter SDK**: [Install Flutter](https://flutter.dev/docs/get-started/install)
- **Dart SDK**: Comes with Flutter
- **Android Studio** or **Xcode** (for emulator/device testing)
- **Git** (optional)

### Verify Installation

```bash
flutter doctor
```

This command checks your Flutter setup and displays any missing dependencies.

## Installation

### 1. Clone or Download the Project

```bash
# If cloning from git
git clone <repository-url>
cd animates_app

# Or navigate to your project folder
cd path/to/animates_app
```

### 2. Get Dependencies

```bash
flutter pub get
```

This installs all required packages from `pubspec.yaml`.

### 3. Verify Project Setup

```bash
flutter doctor -v
```

## Running the App

### On Android Emulator

1. **Start the Android Emulator**

   ```bash
   # List available emulators
   emulator -list-avds

   # Start an emulator (replace 'emulator_name' with your emulator)
   emulator -avd emulator_name
   ```

2. **Run the app**
   ```bash
   cd d:\flutter_project\animates_app
   flutter run
   ```

### On iOS Simulator (macOS only)

```bash
open -a Simulator
flutter run
```

### On Physical Device

1. **Enable Developer Mode** on your device
2. **Connect via USB**
3. **Run the app**
   ```bash
   flutter run
   ```

### Using VS Code

1. Open the project in VS Code
2. Press `F5` or go to **Run** → **Start Debugging**
3. Select your device/emulator from the dropdown

## Project Structure

```
lib/
├── main.dart                 # App entry point with routing
├── screens/
    ├── onboarding_screen.dart    # Onboarding with swipe animation
    └── home_screen.dart          # Home screen with activity tracking
```

## Animations Explained

### 1. Onboarding Screen Entrance Animation

**Type**: Slide + Fade Animation

**How it works:**

- When the app loads, the onboarding content slides up from below
- Simultaneously, the content fades in from transparent to fully opaque
- Duration: 1500ms
- Curve: `Curves.easeOut` for smooth deceleration

**Implementation:**

```dart
_slideAnimation = Tween<Offset>(
  begin: const Offset(0, 0.3),
  end: Offset.zero,
).animate(CurvedAnimation(...));

_opacityAnimation = Tween<double>(
  begin: 0,
  end: 1,
).animate(CurvedAnimation(...));
```

**Visual Effect**: The welcome text and illustrations gracefully appear on screen.

---

### 2. Swipe Up Gesture Animation

**Type**: Vertical Slide Transition

**How it works:**

- Detects when user swipes upward with velocity > 500 pixels/second
- The entire onboarding screen slides upward and exits the viewport
- Simultaneously, the home screen slides up from the bottom
- Duration: 800ms
- Curve: `Curves.easeInOut` for smooth acceleration and deceleration

**Implementation:**

```dart
_swipeAnimation = Tween<Offset>(
  begin: Offset.zero,
  end: const Offset(0, -1),
).animate(CurvedAnimation(...));

// Triggered on swipe
_swipeController.forward().then((_) {
  Navigator.of(context).pushReplacementNamed('/home');
});
```

**Visual Effect**: Smooth screen transition as both screens move vertically.

---

### 3. Color Transition Animation During Swipe

**Type**: Gradient Color Animation

**How it works:**

- While swiping, the background gradient smoothly transitions to a yellow color (#FEDF38)
- Top gradient color changes from beige to yellow
- Bottom gradient color changes to bright yellow
- Duration: 800ms (synchronized with swipe animation)
- Curve: `Curves.easeInOut`

**Implementation:**

```dart
_colorAnimation = ColorTween(
  begin: const Color(0xFFE8D4B8),
  end: const Color(0xFFFEDF38),
).animate(CurvedAnimation(...));

// Dynamic gradient in build
gradient: LinearGradient(
  colors: [
    Color.lerp(const Color(0xFFF5E6D3),
               const Color(0xFFFEDF38),
               _swipeController.value)!,
    _colorAnimation.value ?? const Color(0xFFE8D4B8),
  ],
)
```

**Visual Effect**: The screen becomes progressively more yellow as you swipe up.

---

### 4. Swipe Indicator Animation

**Type**: Bouncing/Floating Animation

**How it works:**

- The up arrow icon bounces up and down to indicate swipe capability
- Uses the main animation controller
- Creates a subtle pulse effect to guide the user
- The up arrow moves 10 pixels up and down continuously

**Implementation:**

```dart
Transform.translate(
  offset: Offset(
    0,
    -10 * (1 - _animationController.value.clamp(0, 0.5) * 2),
  ),
  child: Icon(Icons.expand_less, ...),
)
```

**Visual Effect**: Animated up arrow shows where to swipe.

---

### 5. Home Screen Staggered Animation

**Type**: Staggered Slide + Fade Animation

**How it works:**

- Each element on the home screen animates in sequence with a delay
- Header animates first (0ms delay)
- Activity card animates next (100ms delay)
- Tab buttons animate (200ms delay)
- Upcoming tasks animate (300ms delay)
- Each animation lasts 1200ms total with individual intervals
- Curve: `Curves.easeOut`

**Implementation:**

```dart
_itemAnimations = List.generate(4, (index) {
  return Tween<Offset>(
    begin: const Offset(0, 0.3),
    end: Offset.zero,
  ).animate(
    CurvedAnimation(
      parent: _animationController,
      curve: Interval(0.1 * index, 0.1 * index + 0.4),
    ),
  );
});
```

**Visual Effect**: Content gracefully appears from bottom to top in sequence.

---

### 6. Page Route Custom Transition

**Type**: Vertical Slide Page Transition

**How it works:**

- Custom `PageRouteBuilder` handles navigation between screens
- New screen slides up from the bottom during navigation
- Provides smooth, consistent transitions
- Duration: 800ms
- Reverse Duration: 400ms

**Implementation:**

```dart
PageRouteBuilder(
  pageBuilder: (context, animation, secondaryAnimation) {
    return const HomeScreen();
  },
  transitionsBuilder: (context, animation, secondaryAnimation, child) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).animate(animation),
      child: child,
    );
  },
  transitionDuration: const Duration(milliseconds: 800),
)
```

**Visual Effect**: Smooth sliding entrance of the home screen.

---

## Screen Details

### Onboarding Screen

**Path**: `lib/ui/screens/onboarding_screen.dart`

**Features:**

- Welcoming message: "Ready to Start?"
- Decorative circular elements and concentric circles
- Beige/tan gradient background
- Animated swipe indicator
- Yellow rounded bottom accent
- Swipe-up gesture detection
- Color transition to yellow on swipe

**Interactions:**

- Swipe up to navigate to home screen
- Visual feedback through animations

---

### Home Screen

**Path**: `lib/ui/screens/home_screen.dart`

**Features:**

- Welcome header with user greeting ("Alex Morgan")
- Notification bell with indicator
- Yellow "Your Activity" card showing:
  - Weekly activity percentage (85%)
  - Progress bar
  - Trending indicator (+12%)
  - Arrow button
- Tab buttons (All, Updates, Messages)
- Upcoming tasks list:
  - Project Alpha (due tomorrow)
  - Team Meeting (with video call icon)
  - Design Review (pending approval)
- Yellow floating action button (+)
- Staggered entrance animations

**Interactions:**

- Scrollable content
- Task items with icons and details
- Interactive buttons and FAB

## Recording

https://github.com/user-attachments/assets/3bab2ed7-693d-492d-aa1b-aaf748dbb688




---
