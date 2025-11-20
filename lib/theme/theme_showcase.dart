import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';
import 'app_spacing.dart';

/// Example widget showcasing the theme system
/// This can be used as a reference for implementing themed widgets
class ThemeShowcase extends StatelessWidget {
  const ThemeShowcase({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Showcase'),
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.paddingLG,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Typography Examples
            _buildSection(
              'Typography',
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Display Large', style: AppTypography.displayLarge),
                  AppSpacing.gapVerticalSM,
                  Text('Headline Medium', style: AppTypography.headlineMedium),
                  AppSpacing.gapVerticalSM,
                  Text('Title Large', style: AppTypography.titleLarge),
                  AppSpacing.gapVerticalSM,
                  Text('Body Medium', style: AppTypography.bodyMedium),
                  AppSpacing.gapVerticalSM,
                  Text('Label Small', style: AppTypography.labelSmall),
                ],
              ),
            ),
            
            AppSpacing.gapVerticalXXL,
            
            // Color Examples
            _buildSection(
              'Colors',
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  _buildColorChip('Primary', AppColors.primary),
                  _buildColorChip('Success', AppColors.success),
                  _buildColorChip('Warning', AppColors.warning),
                  _buildColorChip('Error', AppColors.error),
                  _buildColorChip('Info', AppColors.info),
                ],
              ),
            ),
            
            AppSpacing.gapVerticalXXL,
            
            // Button Examples
            _buildSection(
              'Buttons',
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Elevated Button'),
                  ),
                  AppSpacing.gapVerticalSM,
                  OutlinedButton(
                    onPressed: () {},
                    child: const Text('Outlined Button'),
                  ),
                  AppSpacing.gapVerticalSM,
                  TextButton(
                    onPressed: () {},
                    child: const Text('Text Button'),
                  ),
                ],
              ),
            ),
            
            AppSpacing.gapVerticalXXL,
            
            // Card Example
            _buildSection(
              'Cards',
              Card(
                child: Padding(
                  padding: AppSpacing.paddingLG,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Card Title',
                        style: AppTypography.titleLarge,
                      ),
                      AppSpacing.gapVerticalSM,
                      Text(
                        'This is a card with themed styling. It uses the app\'s color scheme and spacing system.',
                        style: AppTypography.bodyMedium.withColor(
                          Theme.of(context).textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            AppSpacing.gapVerticalXXL,
            
            // Badge Examples
            _buildSection(
              'Badges',
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  _buildBadge('NVMe', AppColors.badgeNVMe),
                  _buildBadge('SATA', AppColors.badgeSATA),
                  _buildBadge('USB', AppColors.badgeUSB),
                  _buildBadge('HDD', AppColors.badgeHDD),
                  _buildBadge('SSD', AppColors.badgeSSD),
                ],
              ),
            ),
            
            AppSpacing.gapVerticalXXL,
            
            // Status Indicators
            _buildSection(
              'Status Indicators',
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatusRow('Connected', AppColors.statusConnected),
                  AppSpacing.gapVerticalSM,
                  _buildStatusRow('Disconnected', AppColors.statusDisconnected),
                  AppSpacing.gapVerticalSM,
                  _buildStatusRow('Processing', AppColors.statusProcessing),
                  AppSpacing.gapVerticalSM,
                  _buildStatusRow('Warning', AppColors.statusWarning),
                ],
              ),
            ),
            
            AppSpacing.gapVerticalXXL,
            
            // Progress Indicators
            _buildSection(
              'Progress Indicators',
              Column(
                children: [
                  _buildProgressBar('Low Usage', 25, AppColors.success),
                  AppSpacing.gapVerticalMD,
                  _buildProgressBar('Medium Usage', 60, AppColors.info),
                  AppSpacing.gapVerticalMD,
                  _buildProgressBar('High Usage', 85, AppColors.warning),
                  AppSpacing.gapVerticalMD,
                  _buildProgressBar('Critical Usage', 95, AppColors.error),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSection(String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTypography.headlineMedium,
        ),
        AppSpacing.gapVerticalMD,
        child,
      ],
    );
  }
  
  Widget _buildColorChip(String label, Color color) {
    return Container(
      padding: AppSpacing.paddingMD,
      decoration: BoxDecoration(
        color: color,
        borderRadius: AppSpacing.borderRadiusMD,
      ),
      child: Text(
        label,
        style: AppTypography.labelMedium.withColor(Colors.white),
      ),
    );
  }
  
  Widget _buildBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: AppSpacing.borderRadiusSM,
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        label,
        style: AppTypography.labelSmall.withColor(color),
      ),
    );
  }
  
  Widget _buildStatusRow(String label, Color color) {
    return Row(
      children: [
        Container(
          width: AppSpacing.sm,
          height: AppSpacing.sm,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        AppSpacing.gapHorizontalSM,
        Text(
          label,
          style: AppTypography.bodyMedium,
        ),
      ],
    );
  }
  
  Widget _buildProgressBar(String label, double value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTypography.bodySmall),
            Text(
              '${value.toStringAsFixed(0)}%',
              style: AppTypography.labelSmall.withColor(color),
            ),
          ],
        ),
        AppSpacing.gapVerticalXS,
        ClipRRect(
          borderRadius: AppSpacing.borderRadiusXS,
          child: LinearProgressIndicator(
            value: value / 100,
            backgroundColor: color.withValues(alpha: 0.2),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}
