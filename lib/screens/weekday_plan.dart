import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:recipeapp/widgets/logo_appbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MealPlannerScreen extends StatefulWidget {
  final DateTime startDate;

  const MealPlannerScreen({super.key, required this.startDate});

  @override
  State<MealPlannerScreen> createState() => _MealPlannerScreenState();
}

class _MealPlannerScreenState extends State<MealPlannerScreen> {
  late List<DateTime> _weekDates;
  late Map<String, int> buttonStates;
  bool _showModal = false;
  bool _dontShowAgain = false;

  @override
  void initState() {
    super.initState();
    _initDates();
    _initButtonStates();
    _checkModalPreference();
  }

  Future<void> _checkModalPreference() async {
    final prefs = await SharedPreferences.getInstance();
    final showModal = prefs.getBool('weekday_selection_modal') ?? true;

    if (showModal) {
      // Delay to ensure the screen is built before showing modal
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          setState(() {
            _showModal = true;
          });
        }
      });
    }
  }

  void _initDates() {
    _weekDates = List.generate(
      7,
      (index) => widget.startDate.add(Duration(days: index)),
    );
  }

  void _initButtonStates() {
    buttonStates = {};
    for (int i = 0; i < 7; i++) {
      final dateStr = DateFormat('yyyy-MM-dd').format(_weekDates[i]);
      for (String meal in ['breakfast', 'lunch', 'dinner', 'snack']) {
        buttonStates['$dateStr-$meal'] = 0;
      }
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('E, MMM d yyyy').format(date); // e.g. "Mon, Jan 15"
  }

  void _handleTap(String key) {
    setState(() {
      // Toggle between normal and "disabled look"
      if (buttonStates[key] == 0) {
        buttonStates[key] = 1;
      } else if (buttonStates[key] == 1) {
        buttonStates[key] = 0;
      } else if (buttonStates[key] == 2) {
        buttonStates[key] = 0;
      }
    });
  }

  void _handleDoubleTap(String key) {
    setState(() {
      // Toggle between normal and "custom" (yellow)
      if (buttonStates[key] == 2) {
        buttonStates[key] = 0;
      } else {
        buttonStates[key] = 2;
      }
    });
  }

  Future<void> _handleModalClose() async {
    setState(() {
      _showModal = false;
    });

    if (_dontShowAgain) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('weekday_selection_modal', false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LogoAppbar(showBackButton: false),
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Plan your meals for the week',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.separated(
                      itemCount: 7,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        final date = _weekDates[index];
                        final dateStr = DateFormat('yyyy-MM-dd').format(date);

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                              ),
                              child: Text(
                                _formatDate(date),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children:
                                  [
                                    'breakfast',
                                    'lunch',
                                    'dinner',
                                    'snack',
                                  ].map((meal) {
                                    final key = '$dateStr-$meal';
                                    final state = buttonStates[key] ?? 0;

                                    return GestureDetector(
                                      onTap: () => _handleTap(key),
                                      onDoubleTap: () => _handleDoubleTap(key),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color:
                                              state == 0
                                                  ? Theme.of(
                                                    context,
                                                  ).primaryColor
                                                  : state == 1
                                                  ? Colors.grey[300]
                                                  : Colors.yellow,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          border: Border.all(
                                            color:
                                                state == 1
                                                    ? Colors.grey[400]!
                                                    : Colors.transparent,
                                          ),
                                        ),
                                        child: Text(
                                          state == 2 ? 'custom' : meal,
                                          style: TextStyle(
                                            color:
                                                state == 0
                                                    ? Colors.white
                                                    : state == 1
                                                    ? Colors.grey[600]
                                                    : Colors.black,
                                            fontWeight:
                                                state == 1
                                                    ? FontWeight.normal
                                                    : FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Modal Overlay
          if (_showModal)
            Container(
              color: Colors.black.withValues(alpha: 0.5),
              child: Center(
                child: Card(
                  margin: const EdgeInsets.all(24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'How to Use',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Use this meal planner to organize your weekly meals:',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '• A single tap on a meal will remove it from the plan (shows as greyed out)',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          '• A double tap lets you customize the meal after planning is finished (shows as yellow)',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Checkbox(
                              value: _dontShowAgain,
                              onChanged: (value) {
                                setState(() {
                                  _dontShowAgain = value ?? false;
                                });
                              },
                            ),
                            const Text("Don't show this again"),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Align(
                          alignment: Alignment.center,
                          child: ElevatedButton(
                            onPressed: _handleModalClose,
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(120, 44),
                            ),
                            child: const Text('OK'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
