import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/splash_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _logoController;
  late final List<AnimationController> _letterControllers;
  final String appName = "Fosshati";

  @override
  void initState() {
    super.initState();
    Get.put(SplashController());

    // Logo bounce animation
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _logoController.forward(); // 👈 run once only

    // Letter animation controllers
    _letterControllers = List.generate(appName.length, (index) {
      return AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
      );
    });

    // Staggered animation: letters appear one after another
    for (int i = 0; i < _letterControllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 200), () {
        if (mounted) _letterControllers[i].forward();
      });
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    for (var c in _letterControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        body: Stack(
          children: [
            // Gradient background
            TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: 1),
              duration: const Duration(seconds: 5),
              builder: (context, double value, child) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color.lerp(
                          const Color(0xFF1E88E5),
                          const Color(0xFF1565C0),
                          value,
                        )!,
                        Color.lerp(
                          const Color(0xFF42A5F5),
                          const Color(0xFF0D47A1),
                          value,
                        )!,
                      ],
                    ),
                  ),
                );
              },
            ),

            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Animated Logo
                  ScaleTransition(
                    scale: Tween(begin: 0.8, end: 1.0).animate(
                      CurvedAnimation(
                        parent: _logoController,
                        curve: Curves.easeInOut,
                      ),
                    ),
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(32),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 30,
                            offset: const Offset(0, 15),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Image.asset(
                          'assets/images/Logo_pos.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Letter-by-letter animated app name
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(appName.length, (index) {
                      return AnimatedBuilder(
                        animation: _letterControllers[index],
                        builder: (context, child) {
                          return Opacity(
                            opacity: _letterControllers[index].value,
                            child: child,
                          );
                        },
                        child: Text(
                          appName[index],
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 12),
                  Text(
                    'Fast • Secure • Reliable',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.85),
                      letterSpacing: 0.8,
                    ),
                  ),

                  const SizedBox(height: 50),

                  // Circular Progress
                  SizedBox(
                    width: 36,
                    height: 36,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                  ),
                ],
              ),
            ),

            // Footer
            Positioned(
              bottom: 24,
              left: 0,
              right: 0,
              child: Text(
                '© 2026 Fosshati',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
