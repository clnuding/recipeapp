import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:recipeapp/theme/theme.dart';

class DateRangeSelector extends StatelessWidget {
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onDropdownTap;
  final DateTime startDate;
  final int duration;

  const DateRangeSelector({
    super.key,
    required this.onPrevious,
    required this.onNext,
    required this.onDropdownTap,
    required this.startDate,
    this.duration = 6,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 30,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceBright,
        borderRadius: BorderRadius.circular(SpoonSparkTheme.radiusR),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _iconButton(theme, Icons.chevron_left, onPrevious),
          _verticalDivider(theme),
          GestureDetector(
            onTap: onDropdownTap,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: SpoonSparkTheme.spacingXS,
              ),
              child: Row(
                children: [
                  Text(
                    'Aktuell,  ',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                  Text(
                    DateFormat('E, dd.MM').format(startDate),
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: SpoonSparkTheme.spacingS,
                    ),
                    child: Text('–', style: theme.textTheme.labelMedium),
                  ),

                  Text(
                    DateFormat(
                      'E, dd.MM',
                    ).format(startDate.add(Duration(days: duration))),
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                  const SizedBox(width: SpoonSparkTheme.spacingXS),
                  const Icon(
                    Icons.keyboard_arrow_down,
                    size: SpoonSparkTheme.fontXL,
                  ),
                ],
              ),
            ),
          ),
          _verticalDivider(theme),
          _iconButton(theme, Icons.chevron_right, onNext),
        ],
      ),
    );
  }

  Widget _iconButton(ThemeData theme, IconData icon, VoidCallback onTap) {
    return IconButton(
      icon: Icon(icon, color: theme.colorScheme.secondary),
      onPressed: onTap,
    );
  }

  Widget _verticalDivider(ThemeData theme) {
    return Container(
      height: 16,
      width: 1,
      margin: const EdgeInsets.symmetric(horizontal: SpoonSparkTheme.spacingXS),
      color: theme.colorScheme.secondary.withValues(alpha: 0.2),
    );
  }
}
