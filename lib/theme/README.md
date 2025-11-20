# Swipe App Theme System

This directory contains the complete theming system for the Swipe application, based on the UI designs in the `ui logic` folder.

## Overview

The theme system is designed to match the modern, clean aesthetic of the HTML mockups with:
- Dark mode as the primary theme
- Light mode support
- Consistent spacing, typography, and colors
- Material Design 3 components

## Files

### `app_theme.dart`
Main theme configuration file containing:
- Light and dark theme definitions
- Material Design 3 component themes
- Typography system
- Color schemes

### `app_colors.dart`
Centralized color definitions including:
- Brand colors (Primary blue: #135BEC)
- Semantic colors (success, warning, error, info)
- Text colors for light and dark modes
- Border and overlay colors
- Helper methods for dynamic colors

### `app_typography.dart`
Typography system with:
- Display styles (36px, 32px, 28px)
- Headline styles (24px, 22px, 20px)
- Title styles (18px, 16px, 14px)
- Body styles (16px, 14px, 12px)
- Label styles for buttons and badges
- Monospace style for code/data

### `app_spacing.dart`
Consistent spacing system:
- Base unit: 4px
- Spacing scale: xs (4px) to xxxl (32px)
- Padding and margin helpers
- Gap widgets
- Border radius values
- Icon and button size constants

## Usage

### Basic Setup

The theme is automatically applied in `main.dart`:

```dart
import 'theme/app_theme.dart';

MaterialApp(
  theme: AppTheme.lightTheme(),
  darkTheme: AppTheme.darkTheme(),
  themeMode: ThemeMode.dark, // Default to dark mode
  // ...
)
```

### Using Colors

```dart
import 'package:swipe/theme/app_colors.dart';

// Direct color usage
Container(
  color: AppColors.primary,
  child: Text(
    'Hello',
    style: TextStyle(color: AppColors.textPrimaryDark),
  ),
)

// Using theme extension
Container(
  color: Theme.of(context).cardBackground,
  child: Text(
    'Hello',
    style: TextStyle(color: Theme.of(context).textPrimary),
  ),
)

// Dynamic usage color
Color usageColor = AppColors.getUsageColor(85.5); // Returns warning/error color
```

### Using Typography

```dart
import 'package:swipe/theme/app_typography.dart';

Text(
  'Large Heading',
  style: AppTypography.displayLarge,
)

Text(
  'Body text',
  style: AppTypography.bodyMedium.withColor(AppColors.textSecondary),
)

// Or use theme text styles
Text(
  'Themed text',
  style: Theme.of(context).textTheme.headlineMedium,
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

// Gaps
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
    borderRadius: AppSpacing.borderRadiusLG, // 12px radius
  ),
)
```

## Color Palette

### Brand Colors
- **Primary**: #135BEC (Blue)
- **Background Light**: #F6F6F8
- **Background Dark**: #101622
- **Card Dark**: #1A1D23

### Semantic Colors
- **Success**: #10B981 (Green)
- **Warning**: #FBBF24 (Yellow)
- **Error**: #EF4444 (Red)
- **Info**: #3B82F6 (Blue)

### Text Colors (Dark Mode)
- **Primary**: #FFFFFF (White)
- **Secondary**: #D1D5DB (Light Gray)
- **Tertiary**: #9CA3AF (Medium Gray)

### Text Colors (Light Mode)
- **Primary**: #111827 (Near Black)
- **Secondary**: #6B7280 (Gray)
- **Tertiary**: #9CA3AF (Light Gray)

## Typography Scale

| Style | Size | Weight | Usage |
|-------|------|--------|-------|
| Display Large | 36px | 900 | Page titles |
| Display Medium | 32px | 900 | Section headers |
| Headline Large | 24px | 700 | Card titles |
| Headline Medium | 22px | 700 | Subsection headers |
| Title Large | 18px | 700 | List headers |
| Title Medium | 16px | 600 | Card subtitles |
| Body Large | 16px | 400 | Primary content |
| Body Medium | 14px | 400 | Secondary content |
| Body Small | 12px | 400 | Tertiary content |
| Label Large | 14px | 700 | Buttons |
| Label Medium | 12px | 600 | Badges |
| Label Small | 11px | 500 | Small labels |

## Spacing Scale

| Name | Value | Usage |
|------|-------|-------|
| xs | 4px | Minimal spacing |
| sm | 8px | Tight spacing |
| md | 12px | Default spacing |
| lg | 16px | Comfortable spacing |
| xl | 20px | Loose spacing |
| xxl | 24px | Section spacing |
| xxxl | 32px | Large section spacing |

## Design Principles

1. **Consistency**: Use the defined spacing, typography, and color systems throughout the app
2. **Accessibility**: Maintain proper contrast ratios and touch target sizes
3. **Responsiveness**: Design works across different screen sizes
4. **Dark Mode First**: Primary design is dark mode, with light mode as alternative
5. **Material Design 3**: Follow MD3 guidelines for components and interactions

## Customization

To customize the theme:

1. Update color values in `app_colors.dart`
2. Modify typography in `app_typography.dart`
3. Adjust spacing in `app_spacing.dart`
4. Update component themes in `app_theme.dart`

## Notes

- The Inter font family is loaded via Google Fonts package
- Dark mode uses semi-transparent borders (white with 10% opacity)
- Card backgrounds in dark mode use #1A1D23 for depth
- All border radius values follow the 4px base unit system
