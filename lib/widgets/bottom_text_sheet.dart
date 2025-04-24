import 'package:flutter/material.dart';
import 'package:recipeapp/widgets/atomics/primary_btn.dart';
import 'package:recipeapp/widgets/atomics/secondary_btn.dart';

class BottomSheetModal extends StatelessWidget {
  final String headline;
  final String bodyText;
  final PrimaryButton? primaryBtn;
  final SecondaryButton? secondaryBtn;

  const BottomSheetModal({
    super.key,
    required this.headline,
    required this.bodyText,
    this.primaryBtn,
    this.secondaryBtn,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: 4),
            Text(
              headline,
              style: theme.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            Text(
              bodyText,
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),

            SizedBox(
              width: double.infinity, // <-- now the Row has a finite max width
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (secondaryBtn != null) Expanded(child: secondaryBtn!),
                  if (primaryBtn != null && secondaryBtn != null)
                    SizedBox(width: 12),
                  if (primaryBtn != null) Expanded(child: primaryBtn!),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
