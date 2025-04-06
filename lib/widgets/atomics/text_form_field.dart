import 'package:flutter/material.dart';
import 'package:recipeapp/theme/theme.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController fieldController;
  final String label;
  final bool isSecret;
  final TextInputType? inputType;
  final String? Function(String?)? validator;
  final String? hintText;

  const CustomTextFormField({
    super.key,
    required this.fieldController,
    required this.label,
    this.isSecret = false,
    this.inputType = TextInputType.text,
    this.validator,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextFormField(
      cursorColor: theme.colorScheme.onSurface,
      controller: fieldController,
      validator: validator ?? (_) => null,
      keyboardType: inputType,
      obscureText: isSecret,
      obscuringCharacter: '*',

      // Input styling
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: theme.colorScheme.onSurface,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(SpoonSparkTheme.radiusS),
        ),

        // Customize border when not focused
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: theme.colorScheme.tertiary),
          borderRadius: BorderRadius.circular(SpoonSparkTheme.radiusM),
        ),

        // Customize label color when focused
        floatingLabelStyle: TextStyle(color: theme.colorScheme.onSurface),
        label: Text(label, style: theme.textTheme.bodyMedium),
        hintText: hintText ?? 'Enter $label',
        hintStyle: theme.textTheme.bodyMedium,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: theme.colorScheme.tertiary),
          borderRadius: BorderRadius.circular(SpoonSparkTheme.radiusM),
        ),
      ),
    );
  }
}
