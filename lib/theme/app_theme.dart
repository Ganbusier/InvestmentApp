import 'package:flutter/material.dart';
import 'package:investment_app/models/fund.dart';

class AppTheme {
  static const Color primary = Color(0xFFF59E0B);
  static const Color primaryDark = Color(0xFF0A1929);
  static const Color primaryNavy = Color(0xFF0A1929);
  static const Color secondary = Color(0xFFFBBF24);
  static const Color background = Color(0xFF0F172A);
  static const Color surface = Color(0xFF1E293B);
  static const Color error = Color(0xFFEF5350);
  static const Color warning = Color(0xFFFFA726);
  static const Color success = Color(0xFF26A69A);

  static const Color primaryBlue = Color(0xFF1E3A5F);
  static const Color accentGold = Color(0xFFF59E0B);
  static const Color accentGoldLight = Color(0xFFF4E5B2);
  static const Color accentPurple = Color(0xFF8B5CF6);

  static const Color stockColor = Color(0xFF26A69A);
  static const Color bondColor = Color(0xFF3B82F6);
  static const Color cashColor = Color(0xFF14B8A6);
  static const Color goldColor = Color(0xFFF59E0B);

  static const Color stockColorLight = Color(0xFFE8F5E9);
  static const Color bondColorLight = Color(0xFFE3F2FD);
  static const Color cashColorLight = Color(0xFFE0F2F1);
  static const Color goldColorLight = Color(0xFFFFF8E1);

  static const Color cardBackground = Color(0xFF1E293B);
  static const Color cardBackgroundAlt = Color(0xFF243347);
  static const Color surfaceLight = Color(0xFF334155);
  static const Color navBarBackground = Color(0xFF0D1B2A);
  static const Color deleteColor = Color(0xFFEF5350);
  static const Color deleteColorLight = Color(0x40EF5350);

  static Color white05 = Colors.white.withValues(alpha: 0.05);
  static Color white08 = Colors.white.withValues(alpha: 0.08);
  static Color white10 = Colors.white.withValues(alpha: 0.1);
  static Color white20 = Colors.white.withValues(alpha: 0.2);
  static Color white30 = Colors.white.withValues(alpha: 0.3);
  static Color white40 = Colors.white.withValues(alpha: 0.4);
  static Color white50 = Colors.white.withValues(alpha: 0.5);
  static Color white60 = Colors.white.withValues(alpha: 0.6);
  static Color white70 = Colors.white.withValues(alpha: 0.7);

  static Color gold10 = accentGold.withValues(alpha: 0.1);
  static Color gold15 = accentGold.withValues(alpha: 0.15);
  static Color gold20 = accentGold.withValues(alpha: 0.2);
  static Color gold30 = accentGold.withValues(alpha: 0.3);

  static Color success10 = success.withValues(alpha: 0.1);
  static Color success15 = success.withValues(alpha: 0.15);
  static Color success20 = success.withValues(alpha: 0.2);

  static Color error10 = error.withValues(alpha: 0.1);
  static Color error15 = error.withValues(alpha: 0.15);
  static Color error20 = error.withValues(alpha: 0.2);

  static Color warning10 = warning.withValues(alpha: 0.1);
  static Color warning15 = warning.withValues(alpha: 0.15);
  static Color warning20 = warning.withValues(alpha: 0.2);

  static const TextStyle displayLarge = TextStyle(
    fontSize: 42,
    fontWeight: FontWeight.w700,
    color: Colors.white,
    letterSpacing: -1.5,
  );
  static const TextStyle displayMedium = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: Colors.white,
    letterSpacing: -1,
  );
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: Colors.white,
    letterSpacing: -0.5,
  );
  static const TextStyle headlineMedium = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
  static const TextStyle titleLarge = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
  static const TextStyle titleMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: Color(0xFFB8C5D6),
  );
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Color(0xFF8A9BB5),
  );
  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
  static const TextStyle labelSmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: Color(0xFF8A9BB5),
  );

  static ThemeData get light {
    return ThemeData(
      primaryColor: primary,
      primaryColorDark: primaryDark,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        primary: primary,
        secondary: secondary,
        error: error,
        surface: surface,
        surfaceContainerHighest: background,
        onPrimary: Colors.white,
        onSecondary: primaryDark,
        onSurface: Colors.white,
      ),
      textTheme: const TextTheme(
        displayLarge: displayLarge,
        displayMedium: displayMedium,
        headlineLarge: headlineLarge,
        headlineMedium: headlineMedium,
        titleLarge: titleLarge,
        titleMedium: titleMedium,
        bodyLarge: bodyLarge,
        bodyMedium: bodyMedium,
        labelLarge: labelLarge,
        labelSmall: labelSmall,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentGold,
          foregroundColor: primaryDark,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: accentGold,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: const BorderSide(color: accentGold, width: 1.5),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2D4A6A), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: accentGold, width: 2),
        ),
        hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.4)),
        labelStyle: const TextStyle(color: Color(0xFF8A9BB5)),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: navBarBackground,
        selectedItemColor: accentGold,
        unselectedItemColor: Color(0xFF5A728A),
        selectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        unselectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        selectedIconTheme: IconThemeData(size: 24),
        unselectedIconTheme: IconThemeData(size: 24),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: cardBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        contentTextStyle: const TextStyle(
          fontSize: 15,
          color: Color(0xFFB8C5D6),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: surfaceLight,
        contentTextStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static ThemeData get dark {
    return light;
  }

  static Color getCategoryColor(PortfolioCategory category) {
    switch (category) {
      case PortfolioCategory.stock:
        return stockColor;
      case PortfolioCategory.bond:
        return bondColor;
      case PortfolioCategory.cash:
        return cashColor;
      case PortfolioCategory.gold:
        return goldColor;
    }
  }

  static Color getCategoryLightColor(PortfolioCategory category) {
    switch (category) {
      case PortfolioCategory.stock:
        return stockColorLight;
      case PortfolioCategory.bond:
        return bondColorLight;
      case PortfolioCategory.cash:
        return cashColorLight;
      case PortfolioCategory.gold:
        return goldColorLight;
    }
  }

  static LinearGradient getCategoryGradient(PortfolioCategory category) {
    final color = getCategoryColor(category);
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        color,
        color.withValues(alpha: 0.7),
      ],
    );
  }

  static IconData getCategoryIcon(PortfolioCategory category) {
    switch (category) {
      case PortfolioCategory.stock:
        return Icons.trending_up;
      case PortfolioCategory.bond:
        return Icons.account_balance;
      case PortfolioCategory.cash:
        return Icons.account_balance_wallet;
      case PortfolioCategory.gold:
        return Icons.grain;
    }
  }

  static BoxDecoration getCardDecoration() {
    return BoxDecoration(
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF1E293B),
          Color(0xFF1A2436),
        ],
      ),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: Colors.white.withValues(alpha: 0.08),
        width: 1,
      ),
    );
  }

  static BoxDecoration getPremiumCardDecoration() {
    return BoxDecoration(
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF1E3A5F),
          Color(0xFF0A1929),
        ],
      ),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: accentGold.withValues(alpha: 0.3),
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: accentGold.withValues(alpha: 0.1),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }
}
