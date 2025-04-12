import 'package:flutter/material.dart';
import 'package:recipeapp/theme/theme.dart';

class ModalOverlay extends StatelessWidget {
  final String title;
  final List<Widget> content;
  final bool showDontShowAgain;
  final bool dontShowAgainValue;
  final void Function(bool?)? onDontShowAgainChanged;
  final VoidCallback onClose;

  const ModalOverlay({
    super.key,
    required this.title,
    required this.content,
    this.showDontShowAgain = false,
    this.dontShowAgainValue = false,
    this.onDontShowAgainChanged,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: 0.5),
      child: Center(
        child: Card(
          margin: const EdgeInsets.all(24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SpoonSparkTheme.spacingL),
          ),
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: SpoonSparkTheme.spacingXXL,
              vertical: 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: SpoonSparkTheme.spacingL),
                ...content,
                if (showDontShowAgain) ...[
                  const SizedBox(height: SpoonSparkTheme.spacingXXL),
                  Row(
                    children: [
                      Checkbox(
                        value: dontShowAgainValue,
                        onChanged: onDontShowAgainChanged,
                      ),
                      const Text("Don't show this again"),
                    ],
                  ),
                ],
                const SizedBox(height: SpoonSparkTheme.spacingL),
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: onClose,
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
    );
  }
}
