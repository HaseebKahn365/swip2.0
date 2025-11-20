# Swipe Theme - Quick Reference Card

## 🎨 Import

```dart
import 'package:swipe/theme/theme.dart';
```

## 🌈 Colors

### Brand
```dart
AppColors.primary              // #135BEC
AppColors.backgroundDark       // #101622
AppColors.cardDark            // #1A1D23
AppColors.backgroundLight     // #F6F6F8
```

### Semantic
```dart
AppColors.success             // Green
AppColors.warning             // Yellow
AppColors.error               // Red
AppColors.info                // Blue
```

### Text (Dark Mode)
```dart
AppColors.textPrimaryDark     // White
AppColors.textSecondaryDark   // Light Gray
AppColors.textTertiaryDark    // Medium Gray
```

### Helpers
```dart
AppColors.getUsageColor(85.5)        // Returns color based on percentage
AppColors.getDeviceTypeColor('nvme') // Returns badge color
```

## 📝 Typography

```dart
AppTypography.displayLarge      // 36px, weight 900
AppTypography.headlineMedium    // 22px, weight 700
AppTypography.titleLarge        // 18px, weight 700
AppTypography.bodyMedium        // 14px, weight 400
AppTypography.labelSmall        // 11px, weight 500
```

### Extensions
```dart
AppTypography.bodyMedium.withColor(AppColors.textSecondary)
AppTypography.titleLarge.withWeight(FontWeight.w600)
AppTypography.bodySmall.withOpacity(0.7)
```

## 📏 Spacing

### Values
```dart
AppSpacing.xs    // 4px
AppSpacing.sm    // 8px
AppSpacing.md    // 12px
AppSpacing.lg    // 16px
AppSpacing.xl    // 20px
AppSpacing.xxl   // 24px
```

### Padding
```dart
AppSpacing.paddingLG              // EdgeInsets.all(16)
AppSpacing.paddingHorizontalMD    // EdgeInsets.symmetric(horizontal: 12)
AppSpacing.paddingVerticalSM      // EdgeInsets.symmetric(vertical: 8)
```

### Gaps
```dart
AppSpacing.gapVerticalMD          // SizedBox(height: 12)
AppSpacing.gapHorizontalLG        // SizedBox(width: 16)
```

### Border Radius
```dart
AppSpacing.borderRadiusXS         // 4px
AppSpacing.borderRadiusMD         // 8px
AppSpacing.borderRadiusLG         // 12px
AppSpacing.borderRadiusFull       // 9999px (circular)
```

## 🎯 Common Patterns

### Card with Content
```dart
Card(
  child: Padding(
    padding: AppSpacing.paddingLG,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Title', style: AppTypography.titleLarge),
        AppSpacing.gapVerticalSM,
        Text('Body', style: AppTypography.bodyMedium),
      ],
    ),
  ),
)
```

### Badge
```dart
Container(
  padding: EdgeInsets.symmetric(
    horizontal: AppSpacing.md,
    vertical: AppSpacing.xs,
  ),
  decoration: BoxDecoration(
    color: AppColors.primary.withOpacity(0.1),
    borderRadius: AppSpacing.borderRadiusSM,
    border: Border.all(color: AppColors.primary),
  ),
  child: Text(
    'Badge',
    style: AppTypography.labelSmall.withColor(AppColors.primary),
  ),
)
```

### Progress Bar
```dart
ClipRRect(
  borderRadius: AppSpacing.borderRadiusXS,
  child: LinearProgressIndicator(
    value: 0.75,
    backgroundColor: AppColors.primary.withOpacity(0.2),
    valueColor: AlwaysStoppedAnimation(AppColors.primary),
    minHeight: 8,
  ),
)
```

### Status Indicator
```dart
Row(
  children: [
    Container(
      width: AppSpacing.sm,
      height: AppSpacing.sm,
      decoration: BoxDecoration(
        color: AppColors.success,
        shape: BoxShape.circle,
      ),
    ),
    AppSpacing.gapHorizontalSM,
    Text('Connected', style: AppTypography.bodyMedium),
  ],
)
```

## 🔧 Theme Access

```dart
// Via Theme
Theme.of(context).colorScheme.primary
Theme.of(context).textTheme.headlineMedium
Theme.of(context).cardBackground  // Extension

// Direct
AppColors.primary
AppTypography.titleLarge
AppSpacing.paddingLG
```

## 📱 Responsive

```dart
// Use MediaQuery for responsive layouts
final width = MediaQuery.of(context).size.width;
final isSmall = width < 600;

Padding(
  padding: isSmall 
    ? AppSpacing.paddingMD 
    : AppSpacing.paddingXXL,
  child: child,
)
```

## 🌓 Theme Mode

```dart
// In main.dart
MaterialApp(
  theme: AppTheme.lightTheme(),
  darkTheme: AppTheme.darkTheme(),
  themeMode: ThemeMode.dark,  // or .light, .system
)
```

## 📚 Full Documentation

- **Implementation Guide**: `THEMING_GUIDE.md`
- **Theme Docs**: `lib/theme/README.md`
- **Examples**: `lib/theme/theme_showcase.dart`
- **Summary**: `THEME_SUMMARY.md`
