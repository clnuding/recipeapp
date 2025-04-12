import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:recipeapp/theme/theme.dart';
import 'package:recipeapp/widgets/atomics/appbar.dart';
import 'package:recipeapp/widgets/atomics/legend_item.dart';
import 'package:recipeapp/widgets/atomics/primary_btn.dart';
import 'package:recipeapp/widgets/card_stack.dart';
import 'package:recipeapp/widgets/three_tap_button.dart';

class WeekdayPlanScreen extends StatefulWidget {
  final DateTime startDate;

  const WeekdayPlanScreen({super.key, required this.startDate});

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
      7,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Plane wann du kochen möchtest',
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      LegendItem(
                        color: theme.colorScheme.primary,
                        label: 'geplant (0 Tap)',
                      ),
                      LegendItem(
                        color: theme.colorScheme.secondary.withValues(
                          alpha: 0.2,
                        ),
                        label: 'nicht geplant (1 Tap)',
                      ),
                      LegendItem(
                        color: const Color.fromARGB(255, 255, 226, 146),
                        label: 'plane später (2 Taps)',
                      ),
                    ],
                  ),
                  const SizedBox(height: SpoonSparkTheme.spacingXL),
                  Expanded(
                    child: ListView.builder(
                      itemCount: 7,
                      // separatorBuilder: (context, index) => const Divider(),
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
                ],
              ),
            ),
          ),

          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Center(
              child: SizedBox(
                width: 230,
                child: PrimaryButton(
                  text: "Speichern und Weiter",
                  onPressed: () {
                    // Print the buttonStates map
                    print(buttonStates);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SwipeCardStackScreen(),
                      ),
                    );
                  },
                  icon: Icons.arrow_forward,
                  iconAlignment: IconAlignment.end,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
