import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swipe/theme/theme.dart';
import '../providers/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1400),
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width > 600 ? 40 : 16,
              vertical: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                AppSpacing.gapVerticalXXL,
                _buildPageTitle(context),
                AppSpacing.gapVerticalXXL,
                _buildThemeSection(themeProvider, context),
                AppSpacing.gapVerticalXXL,
                _buildAboutSection(context),
                AppSpacing.gapVerticalXXL,
                _buildFooter(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: AppSpacing.paddingLG,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Logo and title
          Icon(
            Icons.cleaning_services_rounded,
            color: AppColors.primary,
            size: 24,
          ),
          AppSpacing.gapHorizontalSM,
          Text(
            'Swipe',
            style: AppTypography.titleLarge.withColor(
              Theme.of(context).textTheme.bodyLarge!.color!,
            ),
          ),
          const Spacer(),
          // Navigation links
          if (MediaQuery.of(context).size.width > 768) ...[
            _buildNavLink('Home', context),
            AppSpacing.gapHorizontalXXL,
            _buildNavLink('Settings', context, isActive: true),
            AppSpacing.gapHorizontalXXL,
            _buildNavLink('Logs', context),
            AppSpacing.gapHorizontalXXL,
            _buildStatusButton(context),
          ],
        ],
      ),
    );
  }

  Widget _buildNavLink(String label, BuildContext context, {bool isActive = false}) {
    return InkWell(
      onTap: () {
        if (label == 'Home') {
          Navigator.pop(context);
        } else if (label == 'Settings') {
          // Already on settings
        } else if (label == 'Logs') {
          // TODO: Navigate to logs
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        child: Text(
          label,
          style: AppTypography.bodyMedium.withColor(
            isActive
                ? Theme.of(context).textTheme.bodyLarge!.color!
                : Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha: 0.6),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.white.withValues(alpha: 0.1)
            : Colors.black.withValues(alpha: 0.05),
        borderRadius: AppSpacing.borderRadiusMD,
      ),
      child: Text(
        'System Status: Connected',
        style: AppTypography.labelMedium.withColor(
          Theme.of(context).textTheme.bodyLarge!.color!,
        ),
      ),
    );
  }

  Widget _buildPageTitle(BuildContext context) {
    return Padding(
      padding: AppSpacing.paddingLG,
      child: Text(
        'Settings',
        style: AppTypography.displaySmall.withColor(
          Theme.of(context).textTheme.bodyLarge!.color!,
        ),
      ),
    );
  }

  Widget _buildThemeSection(ThemeProvider themeProvider, BuildContext context) {
    return Container(
      margin: AppSpacing.paddingLG,
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: AppSpacing.borderRadiusLG,
        border: Border.all(
          color: Theme.of(context).dividerColor,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: AppSpacing.paddingXL,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Appearance',
                  style: AppTypography.headlineMedium.withColor(
                    Theme.of(context).textTheme.bodyLarge!.color!,
                  ),
                ),
                AppSpacing.gapVerticalSM,
                Text(
                  'Choose how Swipe looks to you. Select a single theme, or sync with your system and automatically switch between day and night themes.',
                  style: AppTypography.bodyMedium.withColor(
                    Theme.of(context).textTheme.bodyMedium!.color!,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: Theme.of(context).dividerColor),
          _buildThemeOption(
            'Light',
            'Day theme with light colors',
            ThemeMode.light,
            Icons.light_mode,
            themeProvider,
            context,
          ),
          Divider(height: 1, color: Theme.of(context).dividerColor),
          _buildThemeOption(
            'Dark',
            'Night theme with dark colors',
            ThemeMode.dark,
            Icons.dark_mode,
            themeProvider,
            context,
          ),
          Divider(height: 1, color: Theme.of(context).dividerColor),
          _buildThemeOption(
            'System',
            'Sync with system theme',
            ThemeMode.system,
            Icons.brightness_auto,
            themeProvider,
            context,
          ),
        ],
      ),
    );
  }

  Widget _buildThemeOption(
    String title,
    String description,
    ThemeMode mode,
    IconData icon,
    ThemeProvider themeProvider,
    BuildContext context,
  ) {
    final isSelected = themeProvider.themeMode == mode;

    return InkWell(
      onTap: () {
        themeProvider.setThemeMode(mode);
      },
      child: Container(
        padding: AppSpacing.paddingXL,
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withValues(alpha: 0.1)
                    : Theme.of(context).brightness == Brightness.dark
                        ? Colors.white.withValues(alpha: 0.05)
                        : Colors.black.withValues(alpha: 0.03),
                borderRadius: AppSpacing.borderRadiusMD,
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : Theme.of(context).dividerColor,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Icon(
                icon,
                color: isSelected
                    ? AppColors.primary
                    : Theme.of(context).textTheme.bodyMedium!.color,
                size: 24,
              ),
            ),
            AppSpacing.gapHorizontalLG,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.titleMedium.withColor(
                      Theme.of(context).textTheme.bodyLarge!.color!,
                    ),
                  ),
                  AppSpacing.gapVerticalXS,
                  Text(
                    description,
                    style: AppTypography.bodySmall.withColor(
                      Theme.of(context).textTheme.bodyMedium!.color!,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: AppColors.primary,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    return Container(
      margin: AppSpacing.paddingLG,
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: AppSpacing.borderRadiusLG,
        border: Border.all(
          color: Theme.of(context).dividerColor,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: AppSpacing.paddingXL,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'About',
                  style: AppTypography.headlineMedium.withColor(
                    Theme.of(context).textTheme.bodyLarge!.color!,
                  ),
                ),
                AppSpacing.gapVerticalSM,
                Text(
                  'Swipe is a professional drive sanitization tool for Linux systems.',
                  style: AppTypography.bodyMedium.withColor(
                    Theme.of(context).textTheme.bodyMedium!.color!,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: Theme.of(context).dividerColor),
          _buildInfoRow('Version', '1.0.0', context),
          Divider(height: 1, color: Theme.of(context).dividerColor),
          _buildInfoRow('Platform', 'Linux', context),
          Divider(height: 1, color: Theme.of(context).dividerColor),
          _buildInfoRow('License', 'MIT', context),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, BuildContext context) {
    return Padding(
      padding: AppSpacing.paddingXL,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTypography.bodyMedium.withColor(
              Theme.of(context).textTheme.bodyMedium!.color!,
            ),
          ),
          Text(
            value,
            style: AppTypography.bodyMedium.withColor(
              Theme.of(context).textTheme.bodyLarge!.color!,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Padding(
      padding: AppSpacing.paddingLG,
      child: Center(
        child: RichText(
          text: TextSpan(
            style: AppTypography.bodySmall.withColor(
              Theme.of(context).textTheme.bodyMedium!.color!,
            ),
            children: [
              const TextSpan(text: 'Swipe v1.0.0 | '),
              TextSpan(
                text: 'Documentation',
                style: AppTypography.bodySmall.withColor(AppColors.primary),
              ),
              const TextSpan(text: ' | '),
              TextSpan(
                text: 'Support',
                style: AppTypography.bodySmall.withColor(AppColors.primary),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
