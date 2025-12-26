import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _swipeController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _swipeAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _swipeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
        );

    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _swipeAnimation =
        Tween<Offset>(begin: Offset.zero, end: const Offset(0, -1)).animate(
          CurvedAnimation(parent: _swipeController, curve: Curves.easeInOut),
        );

    _colorAnimation =
        ColorTween(
          begin: const Color(0xFFE8D4B8),
          end: const Color(0xFFFEDF38),
        ).animate(
          CurvedAnimation(parent: _swipeController, curve: Curves.easeInOut),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _swipeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onVerticalDragEnd: (details) {
          if (details.velocity.pixelsPerSecond.dy < -500) {
            // Swipe up detected
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
