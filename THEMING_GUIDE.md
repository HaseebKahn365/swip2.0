# Swipe App - Theming Implementation Guide

## Overview

A comprehensive theming system has been implemented for the Swipe application based on the UI designs in the `ui logic` folder. The theme system provides a consistent, modern design language across the entire application.

## What's Been Implemented

### 1. Core Theme Files

Located in `lib/theme/`:

- **`app_theme.dart`** - Main theme configuration with light and dark themes
- **`app_colors.dart`** - Centralized color palette and color utilities
- **`app_typography.dart`** - Typography system with consistent text styles
- **`app_spacing.dart`** - Spacing constants and layout helpers
- **`theme_showcase.dart`** - Example widget demonstrating theme usage
- **`README.md`** - Comprehensive documentation

### 2. Design System

#### Colors
- **Primary Blue**: #135BEC (matches UI designs)
- **Dark Background**: #101622
- **Card Background**: #1A1D23
- **Light Background**: #F6F6F8
- Semantic colors: Success (green), Warning (yellow), Error (red), Info (blue)

#### Typography
- **Font Family**: Inter (via Google Fonts)
- **Scale**: Display (36-28px) → Headline (24-20px) → Title (18-14px) → Body (16-12px)
- **Weights**: 900 (Black), 700 (Bold), 600 (SemiBold), 500 (Medium), 400 (Regular)

#### Spacing
- **Base Unit**: 4px
- **Scale**: xs (4px), sm (8px), md (12px), lg (16px), xl (20px), xxl (24px), xxxl (32px)
- Consistent padding, margin, and gap helpers

### 3. Updated Files

- **`lib/main.dart`** - Updated to use new theme system with dark mode as default
- **`pubspec.yaml`** - Added `google_fonts` package dependency

## How to Use

### Basic Theme Usage

The theme is automatically applied throughout the app. Access theme properties via `Theme.of(context)`:

```dart
// Using theme colors
Container(
  color: Theme.of(context).colorScheme.primary,
  child: Text(
    'Hello',
    style: Theme.of(context).textTheme.headlineMedium,
  ),
)
```

### Using Custom Colors

```dart
import 'package:swipe/theme/app_colors.dart';

// Direct color usage
Container(
  color: AppColors.primary,
  decoration: BoxDecoration(
    border: Border.all(color: AppColors.borderDark),
  ),
)

// Dynamic colors
Color usageColor = AppColors.getUsageColor(85.5); // Returns appropriate color
Color deviceColor = AppColors.getDeviceTypeColor('nvme'); // Returns badge color
```

### Using Typography

```dart
import 'package:swipe/theme/app_typography.dart';

Text(
  'Page Title',
  style: AppTypography.displayLarge,
)

Text(
  'Subtitle',
  style: AppTypography.bodyMedium.withColor(AppColors.textSecondary),
)
```

### Using Spacing

```dart
import 'package:swipe/theme/app_spacing.dart';

// Padding
Padding(
  padding: AppSpacing.paddingLG, // 16px all sides
  child: child,
)

// Gaps between widgets
Column(
  children: [
    Widget1(),
    AppSpacing.gapVerticalMD, // 12px vertical gap
    Widget2(),
  ],
)

// Border radius
Container(
  decoration: BoxDecoration(
    borderRadius: AppSpacing.borderRadiusLG, // 12px
  ),
)
```

## Theme Features

### Material Design 3 Components

All Material components are themed:
- ✅ AppBar (dark background, white text)
- ✅ Cards (rounded corners, subtle borders in dark mode)
- ✅ Buttons (Elevated, Outlined, Text)
- ✅ Input fields (rounded, primary color focus)
- ✅ Checkboxes and Radio buttons
- ✅ Progress indicators
- ✅ Dividers

### Dark Mode (Default)

- Background: #101622
- Cards: #1A1D23 with semi-transparent borders
- Text: White primary, light gray secondary
- Optimized for reduced eye strain

### Light Mode

- Background: #F6F6F8
- Cards: White with subtle shadows
- Text: Near-black primary, gray secondary
- Clean, professional appearance

## Testing the Theme

### View Theme Showcase

To see all theme components in action:

```dart
// Add to your navigation or create a test route
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const ThemeShowcase(),
  ),
);
```

### Toggle Theme Mode

To test both light and dark modes:

```dart
// In main.dart, change:
themeMode: ThemeMode.dark,  // or ThemeMode.light, ThemeMode.system
```

## Next Steps

### Applying Theme to Existing Screens

Update your existing screens to use the new theme system:

1. **Replace hardcoded colors** with theme colors or AppColors
2. **Use AppTypography** for consistent text styles
3. **Apply AppSpacing** for consistent layouts
4. **Use themed components** (Cards, Buttons, etc.)

Example refactoring:

```dart
// Before
Container(
  color: Colors.blue.shade700,
  padding: EdgeInsets.all(16),
  child: Text(
    'Title',
    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  ),
)

// After
Container(
  color: AppColors.primary,
  padding: AppSpacing.paddingLG,
  child: Text(
    'Title',
    style: AppTypography.titleLarge,
  ),
)
```

### Customization

To customize the theme:

1. **Colors**: Edit `lib/theme/app_colors.dart`
2. **Typography**: Edit `lib/theme/app_typography.dart`
3. **Spacing**: Edit `lib/theme/app_spacing.dart`
4. **Components**: Edit `lib/theme/app_theme.dart`

## Design Principles

1. **Consistency** - Use defined spacing, typography, and colors throughout
2. **Accessibility** - Maintain proper contrast ratios (WCAG AA compliant)
3. **Responsiveness** - Design adapts to different screen sizes
4. **Dark Mode First** - Primary design is dark mode
5. **Material Design 3** - Follow MD3 guidelines

## Resources

- **Theme Documentation**: `lib/theme/README.md`
- **UI Designs**: `ui logic/` folder (HTML mockups)
- **Theme Showcase**: `lib/theme/theme_showcase.dart`
- **Google Fonts**: [Inter Font Family](https://fonts.google.com/specimen/Inter)

## Package Dependencies

- `google_fonts: ^6.1.0` - For Inter font family

Run `flutter pub get` to install dependencies.

## Verification

All theme files have been verified with no diagnostics errors:
- ✅ lib/main.dart
- ✅ lib/theme/app_theme.dart
- ✅ lib/theme/app_colors.dart
- ✅ lib/theme/app_typography.dart
- ✅ lib/theme/app_spacing.dart

## Support

For questions or issues with the theming system, refer to:
1. `lib/theme/README.md` - Detailed theme documentation
2. `lib/theme/theme_showcase.dart` - Working examples
3. UI mockups in `ui logic/` folder - Original designs

---

**Status**: ✅ Theme system fully implemented and ready for use
**Default Mode**: Dark mode (matching UI designs)
**Font**: Inter (loaded via Google Fonts)
**Material Design**: Version 3
