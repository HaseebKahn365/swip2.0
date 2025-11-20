import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swipe/theme/theme.dart';
import '../blocs/navigation/navigation_cubit.dart';
import '../blocs/navigation/navigation_state.dart';
import 'home_screen.dart';
import 'settings_tab.dart';
import 'logs_tab.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, NavigationState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: Column(
            children: [
              _buildHeader(context, state.currentTab),
              Expanded(
                child: _buildCurrentTab(state.currentTab),
              ),
              _buildFooter(context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, AppTab currentTab) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
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
          // Logo
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
          // Navigation tabs
          _buildNavTab(context, 'Home', AppTab.home, currentTab),
          AppSpacing.gapHorizontalXXL,
          _buildNavTab(context, 'Settings', AppTab.settings, currentTab),
          AppSpacing.gapHorizontalXXL,
          _buildNavTab(context, 'Logs', AppTab.logs, currentTab),
          AppSpacing.gapHorizontalXXL,
          _buildStatusButton(context),
        ],
      ),
    );
  }

  Widget _buildNavTab(
    BuildContext context,
    String label,
    AppTab tab,
    AppTab currentTab,
  ) {
    final isActive = tab == currentTab;
    return InkWell(
      onTap: () => context.read<NavigationCubit>().setTab(tab),
      borderRadius: AppSpacing.borderRadiusMD,
      mouseCursor: SystemMouseCursors.click,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(
          label,
          style: AppTypography.bodyMedium.withColor(
            isActive
                ? Theme.of(context).textTheme.bodyLarge!.color!
                : Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .color!
                    .withValues(alpha: 0.6),
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

  Widget _buildCurrentTab(AppTab currentTab) {
    switch (currentTab) {
      case AppTab.home:
        return const HomeScreen();
      case AppTab.settings:
        return const SettingsTab();
      case AppTab.logs:
        return const LogsTab();
    }
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
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
