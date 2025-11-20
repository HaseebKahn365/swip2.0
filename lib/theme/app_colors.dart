import 'package:flutter/material.dart';

/// Custom color extensions for the app theme
class AppColors {
  // Brand Colors
  static const Color primary = Color(0xFF135BEC);
  static const Color primaryLight = Color(0xFF3B82F6);
  static const Color primaryDark = Color(0xFF0F4FD4);
  
  // Background Colors
  static const Color backgroundLight = Color(0xFFF6F6F8);
  static const Color backgroundDark = Color(0xFF101622);
  static const Color cardDark = Color(0xFF1A1D23);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  
  // Semantic Colors
  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xFF34D399);
  static const Color successDark = Color(0xFF059669);
  
  static const Color warning = Color(0xFFFBBF24);
  static const Color warningLight = Color(0xFFFCD34D);
  static const Color warningDark = Color(0xFFF59E0B);
  
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFF87171);
  static const Color errorDark = Color(0xFFDC2626);
  
  static const Color info = Color(0xFF3B82F6);
  static const Color infoLight = Color(0xFF60A5FA);
  static const Color infoDark = Color(0xFF2563EB);
  
  // Text Colors - Light Theme
  static const Color textPrimaryLight = Color(0xFF111827);
  static const Color textSecondaryLight = Color(0xFF6B7280);
  static const Color textTertiaryLight = Color(0xFF9CA3AF);
  static const Color textDisabledLight = Color(0xFFD1D5DB);
  
  // Text Colors - Dark Theme
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xFFD1D5DB);
  static const Color textTertiaryDark = Color(0xFF9CA3AF);
  static const Color textDisabledDark = Color(0xFF6B7280);
  
  // Border Colors
  static const Color borderLight = Color(0xFFE5E7EB);
  static const Color borderMediumLight = Color(0xFFD1D5DB);
  static const Color borderDark = Color(0xFF374151);
  
  // Overlay Colors
  static Color overlayLight = Colors.black.withValues(alpha: 0.5);
  static Color overlayDark = Colors.black.withValues(alpha: 0.7);
  
  // Badge/Chip Colors
  static const Color badgeNVMe = Color(0xFF8B5CF6);
  static const Color badgeSATA = Color(0xFF06B6D4);
  static const Color badgeUSB = Color(0xFFF59E0B);
  static const Color badgeHDD = Color(0xFF6366F1);
  static const Color badgeSSD = Color(0xFF10B981);
  
  // Status Colors
  static const Color statusConnected = Color(0xFF10B981);
  static const Color statusDisconnected = Color(0xFFEF4444);
  static const Color statusProcessing = Color(0xFF3B82F6);
  static const Color statusWarning = Color(0xFFFBBF24);
  
  // Helper method to get usage color based on percentage
  static Color getUsageColor(double percentage) {
    if (percentage >= 90) return error;
    if (percentage >= 75) return warning;
    if (percentage >= 50) return info;
    return success;
  }
  
  // Helper method to get device type color
  static Color getDeviceTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'nvme':
        return badgeNVMe;
      case 'sata':
        return badgeSATA;
      case 'usb':
        return badgeUSB;
      case 'hdd':
        return badgeHDD;
      case 'ssd':
        return badgeSSD;
      default:
        return textTertiaryLight;
    }
  }
}

/// Extension to add custom colors to ThemeData
extension AppThemeExtension on ThemeData {
  Color get cardBackground => brightness == Brightness.dark 
      ? AppColors.cardDark 
      : AppColors.surfaceLight;
  
  Color get borderColor => brightness == Brightness.dark
      ? Colors.white.withValues(alpha: 0.1)
      : AppColors.borderLight;
  
  Color get textPrimary => brightness == Brightness.dark
      ? AppColors.textPrimaryDark
      : AppColors.textPrimaryLight;
  
  Color get textSecondary => brightness == Brightness.dark
      ? AppColors.textSecondaryDark
      : AppColors.textSecondaryLight;
  
  Color get textTertiary => brightness == Brightness.dark
      ? AppColors.textTertiaryDark
      : AppColors.textTertiaryLight;
  
  Color get overlay => brightness == Brightness.dark
      ? AppColors.overlayDark
      : AppColors.overlayLight;
}
