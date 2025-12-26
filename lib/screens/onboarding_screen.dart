import 'package:flutter/material.dart';

/// OnboardingScreen is the welcome/intro screen of the app
/// It displays a welcome message with animations and handles swipe-up gestures
/// to navigate to the home screen
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

/// State class for OnboardingScreen
/// Uses TickerProviderStateMixin to support multiple animation controllers
class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  // Animation controller for initial entrance animation (fade + slide)
  late AnimationController _animationController;

  // Animation controller for swipe gesture animation
  late AnimationController _swipeController;

  // Animation for sliding content up from bottom on initial load
  late Animation<Offset> _slideAnimation;

  // Animation for fading content in on initial load
  late Animation<double> _opacityAnimation;

  // Animation for sliding entire screen upward when user swipes
  late Animation<Offset> _swipeAnimation;

  // Animation for gradient color transition during swipe (to yellow #FEDF38)
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize the main animation controller for entrance animations
    // Duration: 1500ms for smooth initial appearance
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Initialize the swipe animation controller
    // Duration: 800ms for the swipe-to-navigate animation
    _swipeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Create slide animation: content enters from below (Offset 0, 0.3)
    // and settles to normal position (Offset 0, 0)
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
        );

    // Create opacity animation: content fades in from invisible to visible
    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    // Create swipe animation: entire screen moves up and off screen
    // Offset (0, -1) means moving up by full screen height
    _swipeAnimation =
        Tween<Offset>(begin: Offset.zero, end: const Offset(0, -1)).animate(
          CurvedAnimation(parent: _swipeController, curve: Curves.easeInOut),
        );

    // Create color animation: gradient transitions from tan to yellow during swipe
    _colorAnimation = ColorTween(
      begin: const Color(0xFFE8D4B8), // Original tan color
      end: const Color(0xFFFEDF38), // Target yellow color
    ).animate(
      CurvedAnimation(parent: _swipeController, curve: Curves.easeInOut),
    );

    // Start the entrance animation automatically
    _animationController.forward();
  }

  @override
  void dispose() {
    // Clean up animation controllers to free resources
    _animationController.dispose();
    _swipeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        // Detect vertical drag (swipe) gestures
        onVerticalDragEnd: (details) {
          // Check if swipe velocity is upward and fast enough (> 500 pixels/sec)
          if (details.velocity.pixelsPerSecond.dy < -500) {
            // Start the swipe animation
            _swipeController.forward().then((_) {
              // After animation completes, navigate to home screen
              Navigator.of(context).pushReplacementNamed('/home');
            });
          }
        },
        // AnimatedBuilder rebuilds when _colorAnimation changes
        child: AnimatedBuilder(
          animation: _colorAnimation,
          builder: (context, child) {
            // SlideTransition applies the swipe animation to move screen up
            return SlideTransition(
              position: _swipeAnimation,
              child: Container(
                // Gradient background with dynamic color based on swipe progress
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      // Top color transitions to yellow during swipe
                      Color.lerp(
                        const Color(0xFFF5E6D3),
                        const Color(0xFFFEDF38),
                        _swipeController.value,
                      )!,
                      // Bottom color animates to yellow
                      _colorAnimation.value ?? const Color(0xFFE8D4B8),
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(height: 60),

                    // Main Content Section
                    Expanded(
                      // SlideTransition applies initial slide-up animation
                      child: SlideTransition(
                        position: _slideAnimation,
                        // FadeTransition applies initial fade-in animation
                        child: FadeTransition(
                          opacity: _opacityAnimation,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                const SizedBox(height: 40),

                                // ========== DECORATIVE ILLUSTRATION SECTION ==========
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    // Main circular background (yellow/gold color)
                                    Container(
                                      width: 280,
                                      height: 280,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFFD699),
                                        borderRadius: BorderRadius.circular(100),
                                      ),
                                    ),

                                    // Decorative element: rotated stick/pen on left
                                    Positioned(
                                      top: 40,
                                      left: 30,
                                      child: Transform.rotate(
                                        angle: -0.3,
                                        child: Container(
                                          width: 25,
                                          height: 80,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFD4A574),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        ),
                                      ),
                                    ),

                                    // Decorative element: white circle top right
                                    Positioned(
                                      top: 20,
                                      right: 40,
                                      child: Container(
                                        width: 40,
                                        height: 40,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),

                                    // Decorative element: white circle bottom left
                                    Positioned(
                                      bottom: 50,
                                      left: 40,
                                      child: Container(
                                        width: 35,
                                        height: 35,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),

                                    // Decorative element: white circle bottom right
                                    Positioned(
                                      bottom: 40,
                                      right: 30,
                                      child: Container(
                                        width: 45,
                                        height: 45,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),

                                    // Concentric circles drawn with custom painter
                                    CustomPaint(
                                      size: const Size(200, 200),
                                      painter: ConcentricCirclesPainter(),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 60),

                                // ========== TEXT CONTENT SECTION ==========
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 30),
                                  child: Column(
                                    children: [
                                      // Main heading text
                                      Text(
                                        'Ready to Start?',
                                        style: TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(height: 16),
                                      // Subtitle text describing the app
                                      Text(
                                        'Experience the new way to interact. Everything you need is just a swipe away.',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black54,
                                          height: 1.5,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // ========== BOTTOM SWIPE INDICATOR SECTION ==========
                    Padding(
                      padding: const EdgeInsets.only(bottom: 40),
                      child: Column(
                        children: [
                          // Text label guiding user to swipe
                          const Text(
                            'SWIPE UP TO BEGIN',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.black45,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Animated arrow icon that bounces up and down
                          AnimatedBuilder(
                            animation: _animationController,
                            builder: (context, child) {
                              return Transform.translate(
                                // Move arrow up and down continuously
                                offset: Offset(
                                  0,
                                  -10 *
                                      (1 -
                                          _animationController.value
                                              .clamp(0, 0.5) *
                                              2),
                                ),
                                child: Icon(
                                  Icons.expand_less,
                                  size: 32,
                                  color: Colors.black.withOpacity(0.6),
                                ),
                              );
                            },
                          ),

                          const SizedBox(height: 20),

                          // Yellow rounded bottom accent/indicator
                          Container(
                            width: 120,
                            height: 40,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFD700),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(40),
                                topRight: Radius.circular(40),
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.keyboard_arrow_up,
                                size: 24,
                                color: Colors.black.withOpacity(0.4),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Custom painter for drawing concentric circles in the background
/// These circles provide a decorative ripple effect
class ConcentricCirclesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Calculate center point
    final center = Offset(size.width / 2, size.height / 2);

    // Create paint with semi-transparent white stroke
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Draw 5 concentric circles with increasing radius
    for (int i = 1; i <= 5; i++) {
      canvas.drawCircle(center, (30.0 * i), paint);
    }
  }

  @override
  bool shouldRepaint(ConcentricCirclesPainter oldDelegate) => false;
}
            _swipeController.forward().then((_) {
              Navigator.of(context).pushReplacementNamed('/home');
            });
          }
        },
        child: AnimatedBuilder(
          animation: _colorAnimation,
          builder: (context, child) {
            return SlideTransition(
              position: _swipeAnimation,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.lerp(
                        const Color(0xFFF5E6D3),
                        const Color(0xFFFEDF38),
                        _swipeController.value,
                      )!,
                      _colorAnimation.value ?? const Color(0xFFE8D4B8),
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(height: 60),
                    // Main Content
                    Expanded(
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: FadeTransition(
                          opacity: _opacityAnimation,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                const SizedBox(height: 40),
                                // Decorative Elements and Title
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    // Background circle
                                    Container(
                                      width: 280,
                                      height: 280,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFFD699),
                                        borderRadius: BorderRadius.circular(
                                          100,
                                        ),
                                      ),
                                    ),
                                    // Centered illustration elements
                                    Positioned(
                                      top: 40,
                                      left: 30,
                                      child: Transform.rotate(
                                        angle: -0.3,
                                        child: Container(
                                          width: 25,
                                          height: 80,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFD4A574),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 20,
                                      right: 40,
                                      child: Container(
                                        width: 40,
                                        height: 40,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 50,
                                      left: 40,
                                      child: Container(
                                        width: 35,
                                        height: 35,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 40,
                                      right: 30,
                                      child: Container(
                                        width: 45,
                                        height: 45,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),
                                    // Concentric circles
                                    CustomPaint(
                                      size: const Size(200, 200),
                                      painter: ConcentricCirclesPainter(),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 60),
                                // Text Content
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 30),
                                  child: Column(
                                    children: [
                                      Text(
                                        'Ready to Start?',
                                        style: TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        'Experience the new way to interact. Everything you need is just a swipe away.',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black54,
                                          height: 1.5,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Bottom Section with Swipe Indicator
                    Padding(
                      padding: const EdgeInsets.only(bottom: 40),
                      child: Column(
                        children: [
                          const Text(
                            'SWIPE UP TO BEGIN',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.black45,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Animated swipe indicator
                          AnimatedBuilder(
                            animation: _animationController,
                            builder: (context, child) {
                              return Transform.translate(
                                offset: Offset(
                                  0,
                                  -10 *
                                      (1 -
                                          _animationController.value.clamp(
                                                0,
                                                0.5,
                                              ) *
                                              2),
                                ),
                                child: Icon(
                                  Icons.expand_less,
                                  size: 32,
                                  color: Colors.black.withOpacity(0.6),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 20),
                          // Yellow rounded bottom indicator
                          Container(
                            width: 120,
                            height: 40,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFD700),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(40),
                                topRight: Radius.circular(40),
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.keyboard_arrow_up,
                                size: 24,
                                color: Colors.black.withOpacity(0.4),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class ConcentricCirclesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Draw concentric circles
    for (int i = 1; i <= 5; i++) {
      canvas.drawCircle(center, (30.0 * i), paint);
    }
  }

  @override
  bool shouldRepaint(ConcentricCirclesPainter oldDelegate) => false;
}
