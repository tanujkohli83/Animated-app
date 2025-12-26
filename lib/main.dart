import 'package:flutter/material.dart';
import 'package:animates_app/screens/onboarding_screen.dart';
import 'package:animates_app/screens/home_screen.dart';

/// Entry point of the application
/// Initializes the Flutter app and runs the MyApp widget
void main() {
  runApp(const MyApp());
}

/// Root widget of the application
/// Configures the theme, home screen, and navigation routes
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animates App',
      // Define app theme with Material 3 design
      theme: ThemeData(
        useMaterial3: true,
        // Use yellow as the primary color for accent elements
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellow),
      ),
      // Set OnboardingScreen as the first screen users see
      home: const OnboardingScreen(),
      // Custom route generator for named route navigation
      // This handles page transitions with custom animations
      onGenerateRoute: (settings) {
        // Handle navigation to home screen with custom transition
        if (settings.name == '/home') {
          return PageRouteBuilder(
            // Build the destination page (HomeScreen)
            pageBuilder: (context, animation, secondaryAnimation) {
              return const HomeScreen();
            },
            // Custom transition animation
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              // SlideTransition: new screen slides up from bottom
              return SlideTransition(
                // Animate position from bottom (Offset 0, 1) to normal (Offset 0, 0)
                position:
                    Tween<Offset>(
                      begin: const Offset(0, 1),
                      end: Offset.zero,
                    ).animate(
                      CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeInOut,
                      ),
                    ),
                child: child,
              );
            },
            // Duration of the page transition animation
            transitionDuration: const Duration(milliseconds: 800),
            // Shorter duration for reverse transition (if user goes back)
            reverseTransitionDuration: const Duration(milliseconds: 400),
          );
        }
        // Return null for routes that aren't handled here
        // This will use default navigation behavior
        return null;
      },
    );
  }
}
