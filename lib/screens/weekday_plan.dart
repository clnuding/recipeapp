import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:recipeapp/theme/theme.dart';
import 'package:recipeapp/widgets/atomics/appbar.dart';
import 'package:recipeapp/widgets/atomics/legend_item.dart';
import 'package:recipeapp/widgets/atomics/primary_btn.dart';
import 'package:recipeapp/widgets/atomics/secondary_btn.dart';
import 'package:recipeapp/widgets/card_stack.dart';
import 'package:recipeapp/widgets/three_tap_button.dart';

class WeekdayPlanScreen extends StatefulWidget {
  final DateTime startDate;
  final String userId;
  final String householdId;
  final int duration;

  const WeekdayPlanScreen({
    super.key,
    required this.startDate,
    required this.userId,
    required this.householdId,
    this.duration = 7,
  });

  @override
  State<WeekdayPlanScreen> createState() => _WeekdayPlanScreenState();
}

class _WeekdayPlanScreenState extends State<WeekdayPlanScreen> {
  late List<DateTime> _weekDates;
  late Map<String, Map<String, int>> buttonStates = {};

  @override
  void initState() {
    super.initState();
    _initDates();
    _initButtonStates();
  }

  void _initDates() {
    _weekDates = List.generate(
      widget.duration,
      (index) => widget.startDate.add(Duration(days: index)),
    );
  }

  void _initButtonStates() {
    // For each date, initialize meal buttons with default state.
    for (var date in _weekDates) {
      final dateKey = DateFormat('yyyy-MM-dd').format(date);
      // Default state for all meals is "primary" (which is index 1)
      buttonStates[dateKey] = {
        "breakfast": ButtonState.primary.index,
        "lunch": ButtonState.primary.index,
        "dinner": ButtonState.primary.index,
      };
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('E, MMM d yyyy').format(date); // e.g. "Mon, Jan 15"
  }

  Future<void> _saveMealPlanSelections() async {
    print(buttonStates.entries);
    // // Save each meal selection for the current user in the database.
    // for (var entry in buttonStates.entries) {
    //   final dateStr = entry.key;
    //   final meals = entry.value; // { "breakfast": state, ... }
    //   meals.forEach((mealType, stateIndex) async {
    //     // A state of 0 or 1 could be interpreted as "selected"/"not selected",
    //     // or you can use an enum conversion. Here assume:
    //     // primary (index 0) means planned, secondary (index 1) means not planned,
    //     // tertiary (index 2) means plan later.
    //     // In our DB, we'll save a Boolean flag that is true for a planned meal.
    //     final bool planned = stateIndex == ButtonState.primary.index;
    //     mpService.insertMealPlanSelection(
    //       widget.userId,
    //       dateStr,
    //       mealType,
    //       planned,
    //     );
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: LogoAppbar(showBackButton: true),
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '1. Plane deine Mahlzeiten',
                    style: theme.textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      LegendItem(
                        color: theme.colorScheme.primary,
                        label: 'Mahlzeit hinzufügen',
                      ),
                      LegendItem(
                        color: theme.colorScheme.secondary.withValues(
                          alpha: 0.2,
                        ),
                        label: 'Mahlzeit entfernen / manuell planen',
                      ),
                      // LegendItem(
                      //   color: const Color.fromARGB(255, 255, 226, 146),
                      //   label: 'plane später (2 Taps)',
                      // ),
                    ],
                  ),
                  const SizedBox(height: SpoonSparkTheme.spacingM),
                  Expanded(
                    child: ListView.builder(
                      itemCount: widget.duration,
                      itemBuilder: (context, index) {
                        final date = _weekDates[index];
                        final dateStr = DateFormat('yyyy-MM-dd').format(date);
                        final mealTypes = ["breakfast", "lunch", "dinner"];

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 6.0,
                              ),
                              child: Text(
                                _formatDate(date),
                                style: theme.textTheme.labelLarge,
                              ),
                            ),
                            ActionButtonsRow(
                              // Pass the date string so the callback can update the correct day
                              dayKey: dateStr,
                              // Callback receives the meal button index and the new state.
                              onButtonStateChanged: (buttonIndex, newState) {
                                setState(() {
                                  // Use the mealTypes list to map index to meal type.
                                  buttonStates[dateStr]![mealTypes[buttonIndex]] =
                                      newState.index;
                                });
                              },
                            ),
                            const SizedBox(height: 16),
                          ],
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: SpoonSparkTheme.spacingS,
                    ),
                    child: Row(
                      children: [
                        // Secondary button
                        Expanded(
                          child: SecondaryButton(
                            text: 'Zurück',
                            onPressed: Navigator.of(context).pop,
                          ),
                        ),

                        const SizedBox(width: SpoonSparkTheme.spacingL),

                        // Primary button
                        Expanded(
                          child: PrimaryButton(
                            text: 'Weiter',
                            onPressed: () {
                              _saveMealPlanSelections();
                              // Navigate to the date selection screen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => SwipeCardStackScreen(
                                        userId: widget.userId,
                                        householdId: widget.householdId,
                                      ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
