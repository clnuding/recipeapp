import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:recipeapp/api/pb_client.dart';
import 'package:recipeapp/screens/main_screen.dart';
import 'package:recipeapp/screens/weekday_plan.dart';
import 'package:recipeapp/theme/theme.dart';
import 'package:recipeapp/widgets/atomics/appbar.dart';
import 'package:recipeapp/widgets/atomics/primary_btn.dart';
import 'package:recipeapp/widgets/atomics/secondary_btn.dart';

class MealPlanIntroScreen extends StatelessWidget {
  final DateTime startDate;
  final String userId;
  final String householdId;
  final int duration;

  const MealPlanIntroScreen({
    super.key,
    required this.userId,
    required this.householdId,
    required this.startDate,
    this.duration = 7,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final DateTime periodStartDate = startDate;
    final DateTime periodEndDate = periodStartDate.add(
      Duration(days: duration - 1),
    );
    final DateFormat dateFormatter = DateFormat('dd MMMM yyyy');

    return Scaffold(
      appBar: LogoAppbar(showBackButton: false),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(SpoonSparkTheme.spacingXXL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Icon and spacing
              const SizedBox(height: SpoonSparkTheme.spacingXXL),
              Icon(
                Icons.restaurant_menu,
                size: 80,
                color: Theme.of(context).primaryColor,
              ),

              const SizedBox(height: SpoonSparkTheme.spacingXXL),

              // Heading text
              Text(
                'Starte die Essensplanung für einen Zeitraum',
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineLarge,
              ),

              // const SizedBox(height: SpoonSparkTheme.spacingXXL),
              const Spacer(flex: 1),

              // Date range box
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: SpoonSparkTheme.spacingXXL,
                  horizontal: SpoonSparkTheme.spacingXL,
                ),
                decoration: BoxDecoration(
                  // color: Colors.grey.shade100,
                  color: theme.colorScheme.surfaceBright,
                  borderRadius: BorderRadius.circular(SpoonSparkTheme.radiusL),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.10),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'Nächster Zeitraum',
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Start:',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.secondary,
                              ),
                            ),
                            const SizedBox(height: SpoonSparkTheme.spacingXS),
                            Text(
                              dateFormatter.format(periodStartDate),
                              style: theme.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: SpoonSparkTheme.spacingM,
                          ),
                          child: SizedBox(height: 35, child: VerticalDivider()),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ende:',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.secondary,
                              ),
                            ),
                            const SizedBox(height: SpoonSparkTheme.spacingXS),
                            Text(
                              dateFormatter.format(periodEndDate),
                              style: theme.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: SpoonSparkTheme.spacingM),
                    Text(
                      '${periodEndDate.difference(periodStartDate).inDays + 1} days',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(flex: 2),

              // Buttons row
              Padding(
                padding: const EdgeInsets.only(top: SpoonSparkTheme.spacingS),
                child: Row(
                  children: [
                    // Secondary button
                    Expanded(
                      child: SecondaryButton(
                        text: 'Abbrechen',
                        onPressed:
                            () => Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MainScreen(),
                              ),
                              (route) => false,
                            ),
                      ),
                    ),

                    const SizedBox(width: SpoonSparkTheme.spacingL),

                    // Primary button
                    Expanded(
                      child: PrimaryButton(
                        icon: Icons.start,
                        iconAlignment: IconAlignment.end,
                        text: 'Starten',
                        onPressed: () async {
                          final navigator = Navigator.of(context);

                          // create meal plan in db
                          mpService.createMealPlan(
                            householdId,
                            periodStartDate,
                          );

                          // Navigate to the date selection screen
                          navigator.push(
                            MaterialPageRoute(
                              builder:
                                  (context) => WeekdayPlanScreen(
                                    startDate: periodStartDate,
                                    userId: userId,
                                    householdId: householdId,
                                    duration: duration,
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
    );
  }
}
