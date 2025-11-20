import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swipe/theme/theme.dart';
import '../blocs/theme/theme_cubit.dart';
import '../blocs/theme/theme_state.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1400),
          padding: const EdgeInsets.all(40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Settings',
                style: AppTypography.displaySmall.withColor(
                  Theme.of(context).textTheme.bodyLarge!.color!,
                ),
              ),
              AppSpacing.gapVerticalXXL,
              _buildThemeSection(context),
              AppSpacing.gapVerticalXXL,
              _buildAboutSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThemeSection(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return Container(
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
                context,
                'Light',
                'Day theme with light colors',
                ThemeMode.light,
                Icons.light_mode,
                state.themeMode,
              ),
              Divider(height: 1, color: Theme.of(context).dividerColor),
              _buildThemeOption(
                context,
                'Dark',
                'Night theme with dark colors',
                ThemeMode.dark,
                Icons.dark_mode,
                state.themeMode,
              ),
              Divider(height: 1, color: Theme.of(context).dividerColor),
              _buildThemeOption(
                context,
                'System',
                'Sync with system theme',
                ThemeMode.system,
                Icons.brightness_auto,
                state.themeMode,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    String title,
    String description,
    ThemeMode mode,
    IconData icon,
    ThemeMode currentMode,
  ) {
    final isSelected = currentMode == mode;

    return InkWell(
      onTap: () => context.read<ThemeCubit>().setThemeMode(mode),
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
          _buildInfoRow(context, 'Version', '1.0.0'),
          Divider(height: 1, color: Theme.of(context).dividerColor),
          _buildInfoRow(context, 'Platform', 'Linux'),
          Divider(height: 1, color: Theme.of(context).dividerColor),
          _buildInfoRow(context, 'License', 'MIT'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
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
}
