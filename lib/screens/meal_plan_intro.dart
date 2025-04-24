import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:recipeapp/api/pb_client.dart';
import 'package:recipeapp/models/meal.dart';
import 'package:recipeapp/screens/main_screen.dart';
import 'package:recipeapp/screens/weekday_plan.dart';
import 'package:recipeapp/theme/theme.dart';
import 'package:recipeapp/widgets/atomics/appbar.dart';
import 'package:recipeapp/widgets/atomics/primary_btn.dart';
import 'package:recipeapp/widgets/atomics/secondary_btn.dart';
import 'package:recipeapp/widgets/bottom_text_sheet.dart';

class MealPlanIntroScreen extends StatefulWidget {
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
  _MealPlanIntroScreenState createState() => _MealPlanIntroScreenState();
}

class _MealPlanIntroScreenState extends State<MealPlanIntroScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late MealPlan? existingMealPlan;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      existingMealPlan = await mpService.mealPlanExists(
        widget.startDate,
        widget.householdId,
      );
      if (existingMealPlan != null &&
          existingMealPlan!.userId == widget.userId) {
        _show();
      }
    });
  }

  void _show() {
    showModalBottomSheet(
      enableDrag: false,
      isDismissible: false,
      elevation: 10,
      context: context,
      builder:
          (ctx) => BottomSheetModal(
            headline: 'Planung bereits getätigt?',
            bodyText:
                """Wir haben für deinen Haushalt bereits einen Plan gefunden, der am ${DateFormat('dd MMMM yyyy').format(widget.startDate)} started. Mit einem Tap auf "Neuer Plan" kannst du deinen bestehenden Plan überschreiben. Der vorherige Plan geht dabei verloren.""",
            primaryBtn: PrimaryButton(
              text: 'Neuer Plan',
              onPressed: () async {
                await mpService.deleteMealPlan(existingMealPlan!.id);
                Navigator.pop(ctx);
              },
            ),
            secondaryBtn: SecondaryButton(
              text: 'Abbrechen',
              onPressed:
                  () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const MainScreen()),
                    (route) => false,
                  ),
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final periodStartDate = widget.startDate;
    final periodEndDate = periodStartDate.add(
      Duration(days: widget.duration - 1),
    );
    final dateFormatter = DateFormat('dd MMMM yyyy');

    return Scaffold(
      key: _scaffoldKey, // ← attach your key here
      appBar: LogoAppbar(showBackButton: false),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(SpoonSparkTheme.spacingXXL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: SpoonSparkTheme.spacingXXL),
              Icon(Icons.restaurant_menu, size: 80, color: theme.primaryColor),
              const SizedBox(height: SpoonSparkTheme.spacingXXL),
              Text(
                'Starte die Essensplanung für einen Zeitraum',
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineLarge,
              ),
              const Spacer(flex: 1),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: SpoonSparkTheme.spacingXXL,
                  horizontal: SpoonSparkTheme.spacingXL,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceBright,
                  borderRadius: BorderRadius.circular(SpoonSparkTheme.radiusL),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(25),
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
                        _DateColumn(
                          label: 'Start:',
                          date: periodStartDate,
                          formatter: dateFormatter,
                        ),
                        const SizedBox(width: SpoonSparkTheme.spacingM),
                        const SizedBox(height: 35, child: VerticalDivider()),
                        const SizedBox(width: SpoonSparkTheme.spacingM),
                        _DateColumn(
                          label: 'Ende:',
                          date: periodEndDate,
                          formatter: dateFormatter,
                        ),
                      ],
                    ),
                    const SizedBox(height: SpoonSparkTheme.spacingM),
                    Text(
                      '${periodEndDate.difference(periodStartDate).inDays + 1} Tage',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(flex: 2),
              Padding(
                padding: const EdgeInsets.only(top: SpoonSparkTheme.spacingS),
                child: Row(
                  children: [
                    Expanded(
                      child: SecondaryButton(
                        text: 'Abbrechen',
                        onPressed:
                            () => Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const MainScreen(),
                              ),
                              (route) => false,
                            ),
                      ),
                    ),
                    const SizedBox(width: SpoonSparkTheme.spacingL),
                    Expanded(
                      child: PrimaryButton(
                        icon: Icons.start,
                        iconAlignment: IconAlignment.end,
                        text: 'Starten',
                        onPressed: () async {
                          final navigator = Navigator.of(context);

                          // create meal plan in db
                          mpService.createMealPlan(
                            widget.householdId,
                            periodStartDate,
                          );

                          // Navigate to the date selection screen
                          navigator.pushReplacement(
                            MaterialPageRoute(
                              builder:
                                  (context) => WeekdayPlanScreen(
                                    startDate: periodStartDate,
                                    userId: widget.userId,
                                    householdId: widget.householdId,
                                    duration: widget.duration,
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

class _DateColumn extends StatelessWidget {
  final String label;
  final DateTime date;
  final DateFormat formatter;

  const _DateColumn({
    required this.label,
    required this.date,
    required this.formatter,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.secondary,
          ),
        ),
        const SizedBox(height: SpoonSparkTheme.spacingXS),
        Text(formatter.format(date), style: theme.textTheme.bodyMedium),
      ],
    );
  }
}
