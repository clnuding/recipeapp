import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:recipeapp/screens/weekday_plan.dart';

class MealPlanPeriodScreen extends StatefulWidget {
  final String userId;
  final String householdId;

  const MealPlanPeriodScreen({
    super.key,
    required this.userId,
    required this.householdId,
  });

  @override
  State<MealPlanPeriodScreen> createState() => _MealPlanPeriodScreenState();
}

class _MealPlanPeriodScreenState extends State<MealPlanPeriodScreen> {
  DateTime selectedDate = DateTime.now();
  int duration = 7;
  final DateFormat dateFormatter = DateFormat('EEEE, MMMM d, yyyy');

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Plan Your Meals'), elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Step 1: Select Date & Duration',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),

            // Date Selection
            const Text(
              'Start Date:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: () => _selectDate(context),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      dateFormatter.format(selectedDate),
                      style: const TextStyle(fontSize: 16),
                    ),
                    const Icon(Icons.calendar_today),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Duration Selection
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Plan Duration:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                Text(
                  '$duration ${duration == 1 ? 'day' : 'days'}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: Theme.of(context).primaryColor,
                inactiveTrackColor: Colors.grey.shade300,
                thumbColor: Theme.of(context).primaryColor,
                overlayColor: Theme.of(
                  context,
                ).primaryColor.withValues(alpha: 0.2),
                valueIndicatorColor: Theme.of(context).primaryColor,
                valueIndicatorTextStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              child: Slider(
                min: 1,
                max: 7,
                divisions: 6,
                value: duration.toDouble(),
                label: '$duration ${duration == 1 ? 'day' : 'days'}',
                onChanged: (value) {
                  setState(() {
                    duration = value.round();
                  });
                },
              ),
            ),

            // Preview section
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Meal Plan Preview:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'From: ${dateFormatter.format(selectedDate)}',
                    style: const TextStyle(fontSize: 14),
                  ),
                  Text(
                    'To: ${dateFormatter.format(selectedDate.add(Duration(days: duration - 1)))}',
                    style: const TextStyle(fontSize: 14),
                  ),
                  Text(
                    'Duration: $duration ${duration == 1 ? 'day' : 'days'}',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Pass selectedDate and durationDays to the next screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => WeekdayPlanScreen(
                    startDate: selectedDate,
                    duration: duration,
                    userId: widget.userId,
                    householdId: widget.householdId,
                  ),
            ),
          );
        },
        child: const Icon(Icons.arrow_forward),
      ),
    );
  }
}
