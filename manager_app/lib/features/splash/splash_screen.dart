import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_colors.dart';
import '../authentication/providers/auth_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _entranceController;
  late AnimationController _pulseController;
  late AnimationController _dotsController;

  // Entrance animations
  late Animation<double> _badgeScale;
  late Animation<double> _badgeFade;
  late Animation<double> _textFade;
  late Animation<Offset> _textSlide;
  late Animation<double> _footerFade;

  @override
  void initState() {
    super.initState();

    // 1. Entrance Animation Controller (900ms)
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _badgeScale = Tween<double>(begin: 0.75, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOutBack),
      ),
    );

    _badgeFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _textFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.25, 0.85, curve: Curves.easeOut),
      ),
    );

    _textSlide = Tween<Offset>(
      begin: const Offset(0, 24),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.25, 0.85, curve: Curves.easeOutCubic),
      ),
    );

    _footerFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.6, 1.0, curve: Curves.easeIn),
      ),
    );

    // 2. Continuous Glow Pulse Controller (~1.8s loop)
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    // 3. Loading Dots Controller (~1.2s loop)
    _dotsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    _entranceController.forward();
    _navigateToLogin();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _pulseController.dispose();
    _dotsController.dispose();
    super.dispose();
  }

  Future<void> _navigateToLogin() async {
    await Future.delayed(const Duration(milliseconds: 1800));
    if (mounted) {
      await ref.read(authProvider.notifier).checkInitialAuth();
    }
  }

  Widget _buildLoadingDot(int index) {
    return AnimatedBuilder(
      animation: _dotsController,
      builder: (context, child) {
        final progress = (_dotsController.value - (index * 0.2)) % 1.0;
        final opacity = (0.3 + 0.7 * (0.5 + 0.5 * math.sin(progress * 2 * math.pi))).clamp(0.2, 1.0);
        return Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withAlpha((opacity * 255).round()),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primary,
              Color(0xFF1B5E20), // Rich forest green bottom gradient
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Main Centered Content
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Badge with Entrance + Looping Glow Pulse
                    AnimatedBuilder(
                      animation: Listenable.merge([_entranceController, _pulseController]),
                      builder: (context, child) {
                        final pulseScale = 1.0 + (_pulseController.value * 0.12);
                        final pulseAlpha = (60 + (_pulseController.value * 50)).round();

                        return Transform.scale(
                          scale: _badgeScale.value,
                          child: Opacity(
                            opacity: _badgeFade.value,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Outer Glowing Aura
                                Transform.scale(
                                  scale: pulseScale,
                                  child: Container(
                                    width: 140,
                                    height: 140,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white.withAlpha(pulseAlpha),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFF81C784).withAlpha(128),
                                          blurRadius: 35,
                                          spreadRadius: 8,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                // Inner Circular Badge
                                Container(
                                  width: 104,
                                  height: 104,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white.withAlpha(56),
                                    border: Border.all(
                                      color: Colors.white.withAlpha(90),
                                      width: 1.5,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withAlpha(30),
                                        blurRadius: 16,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: ClipOval(
                                    child: Image.asset(
                                      'assets/icon/app_icon.png',
                                      width: 54,
                                      height: 54,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 36),

                    // Staggered Title & Subtitle Fade + Slide Up
                    AnimatedBuilder(
                      animation: _entranceController,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: _textSlide.value,
                          child: Opacity(
                            opacity: _textFade.value,
                            child: Column(
                              children: [
                                  const Text(
                                    'Maram Milk',
                                    style: TextStyle(
                                      fontFamily: 'NautilusPompilius',
                                      color: Colors.white,
                                      fontSize: 48,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 2.0,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black26,
                                          blurRadius: 8,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                  ),
                                const SizedBox(height: 10),
                                Text(
                                  'Morning operations, simplified.',
                                  style: TextStyle(
                                    color: Colors.white.withAlpha(217),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w300,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 48),

                    // Loading Dots
                    AnimatedBuilder(
                      animation: _entranceController,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _textFade.value,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildLoadingDot(0),
                              _buildLoadingDot(1),
                              _buildLoadingDot(2),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              // Footer Branding Text
              Positioned(
                bottom: 24,
                left: 0,
                right: 0,
                child: AnimatedBuilder(
                  animation: _entranceController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _footerFade.value,
                      child: Text(
                        'Maram Dairy Systems',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withAlpha(140),
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                          letterSpacing: 1.0,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
