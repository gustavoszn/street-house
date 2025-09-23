import 'package:flutter/material.dart';

class AppColors {
  static const Color purpleGradientStart = Color(0xFFA770EF);
  static const Color purpleGradientMiddle = Color(0xFF7B6BFF);
  static const Color purpleGradientEnd = Color(0xFF4AA3FF);
  static const Color purpleHighlight = Color(0xFF7E3FF2);
  static const Color purpleLight = Color(0xFF9F7FEF);
  static const Color orange = Color(0xFFFF8A5B);
  static const Color textGray = Color(0xFF6B6B6B);
  static const Color lightGray = Color(0xFFE6E6E6);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF111111);
  static const Color error = Color(0xFFFF3B30);
  static const Color success = Color(0xFF34C759);
  static const Color placeholder = Color(0xFFBDBDBD);
}

class AppTextStyles {
  static const h1 = TextStyle(
    fontFamily: 'Inter',
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.black,
  );
  static const h2 = TextStyle(
    fontFamily: 'Inter',
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.black,
  );
  static const subtitle = TextStyle(
    fontFamily: 'Inter',
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.black,
  );
  static const body = TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textGray,
  );
  static const small = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textGray,
  );
  static const caption = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.lightGray,
  );
}

class AppRadius {
  static const double card = 20.0;
  static const double form = 16.0;
  static const double input = 10.0;
  static const double pill = 24.0;
}

class AppShadows {
  static final card = [
    BoxShadow(
      color: Colors.black.withOpacity(0.12),
      blurRadius: 20,
      offset: Offset(0, 10),
    ),
  ];
  static final button = [
    BoxShadow(
      color: Colors.black.withOpacity(0.10),
      blurRadius: 10,
      offset: Offset(0, 4),
    ),
  ];
}

class AppSpacing {
  static const double vertical = 20.0;
  static const double horizontal = 24.0;
  static const double inner = 14.0;
}