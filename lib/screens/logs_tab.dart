import 'package:flutter/material.dart';
import 'package:swipe/theme/theme.dart';

class LogsTab extends StatelessWidget {
  const LogsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1400),
        padding: const EdgeInsets.all(40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Logs',
              style: AppTypography.displaySmall.withColor(
                Theme.of(context).textTheme.bodyLarge!.color!,
              ),
            ),
            AppSpacing.gapVerticalLG,
            Text(
              'Log viewer coming soon...',
              style: AppTypography.bodyMedium.withColor(
                Theme.of(context).textTheme.bodyMedium!.color!,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
