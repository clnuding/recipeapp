// lib/pb_client.dart
import 'package:pocketbase/pocketbase.dart';
import 'package:recipeapp/api/meal_plan.dart';

final pb = PocketBase('https://pocketbase.accelizen.com');
final mpService = MealPlannerService();
