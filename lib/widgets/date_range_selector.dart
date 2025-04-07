import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:recipeapp/theme/theme.dart';

class DateRangeSelector extends StatelessWidget {
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onDropdownTap;
  final DateTime startDate;
  final num duration = 6;

  const DateRangeSelector({
    super.key,
    required this.onPrevious,
    required this.onNext,
    required this.onDropdownTap,
    required this.startDate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 30,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _iconButton(theme, Icons.chevron_left, onPrevious),
          _verticalDivider(theme),
          GestureDetector(
            onTap: onDropdownTap,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                children: [
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
                    child: Text('–', style: TextStyle(fontSize: 10)),
                  ),

                  Text(
                    DateFormat(
                      'E, dd.MM',
                    ).format(startDate.add(const Duration(days: 6))),
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.keyboard_arrow_down, size: 18),
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
      icon: Icon(icon, size: 20, color: theme.colorScheme.secondary),
      onPressed: onTap,
    );
  }

  Widget _verticalDivider(ThemeData theme) {
    return Container(
      height: 16,
      width: 1,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      color: theme.colorScheme.secondary.withValues(alpha: 0.2),
    );
  }
}
