import 'package:flutter/material.dart';

class AppConstants {
  // Corner Radius Constants
  static const double cardRadius = 18.0;
  static const double buttonRadius = 12.0;

  // Spacing Constants
  static const double spacing4 = 4.0;
  static const double spacing8 = 8.0;
  static const double spacing12 = 12.0;
  static const double spacing16 = 16.0;
  static const double spacing24 = 24.0;
  static const double spacing32 = 32.0;

  // Card Drop Shadow Definitions
  static final List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.05),
      blurRadius: 12,
      offset: const Offset(0, 4),
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.02),
      blurRadius: 4,
      offset: const Offset(0, 1),
      spreadRadius: 0,
    ),
  ];

  static final List<BoxShadow> primaryCardShadow = [
    BoxShadow(
      color: const Color(0xFF226E27).withValues(alpha: 0.2),
      blurRadius: 16,
      offset: const Offset(0, 6),
      spreadRadius: 0,
    ),
  ];

  static final Border cardBorder = Border.all(
    color: Colors.black.withValues(alpha: 0.05),
    width: 1,
  );
}
