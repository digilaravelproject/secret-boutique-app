import 'package:flutter/material.dart';

/// Centralized color palette for The Secret Boutique / Lingerie Luxe.
/// Deep rich burgundy, luxury rose gold, soft blush pinks, and elegant neutrals.
class AppColors {
  AppColors._();

  // Primary Brand Colors (Burgundy / Deep Wine)
  static const Color primary = Color(0xFF6E0D36);
  static const Color primaryDark = Color(0xFF4E0724);
  static const Color primaryLight = Color(0xFF8E1B4A);
  static const Color primaryDeep = Color(0xFF3F041D);

  // Accent & Rose Gold Colors
  static const Color accent = Color(0xFFE84D75);
  static const Color accentLight = Color(0xFFFF6F91);
  static const Color roseGold = Color(0xFFB76E79);
  static const Color gold = Color(0xFFDFB15B);

  // Background & Surface Colors
  static const Color scaffoldBackground = Color(0xFFFBF5F7);
  static const Color surface = Colors.white;
  static const Color blushPink = Color(0xFFFDF0F3);
  static const Color lightPink = Color(0xFFFCE4EC);
  static const Color chipBackground = Color(0xFFF7EBF0);

  // Text Colors
  static const Color textPrimary = Color(0xFF26101B);
  static const Color textSecondary = Color(0xFF7D6B74);
  static const Color textMuted = Color(0xFFA5949C);
  static const Color textLight = Colors.white;

  // Status & Utility Colors
  static const Color discountBadge = Color(0xFFD32F2F);
  static const Color success = Color(0xFF2E7D32);
  static const Color ratingStar = Color(0xFFF5A623);
  static const Color divider = Color(0xFFF0DDE4);
  static const Color border = Color(0xFFE8D5DC);
  static const Color error = Color(0xFFC62828);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF861144),
      Color(0xFF6E0D36),
      Color(0xFF4A0624),
    ],
  );

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF861144),
      Color(0xFF5D082C),
    ],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFFF0F5),
      Color(0xFFFDE4EC),
    ],
  );

  static const LinearGradient promoBannerGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFFFDEAEF),
      Color(0xFFF8CFDA),
      Color(0xFFF4BDCC),
    ],
  );
}
