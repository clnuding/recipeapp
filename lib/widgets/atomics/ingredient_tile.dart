import 'package:flutter/material.dart';

class IngredientTile extends StatelessWidget {
  final String name;
  final double? amount;
  final String? unit;
  final Widget? trailing;

  const IngredientTile({
    super.key,
    required this.name,
    this.amount,
    this.unit,
    this.trailing,
  });

  String _formatNumber(double value) {
    return value % 1 == 0 ? value.toInt().toString() : value.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(255, 234, 234, 234),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
              if (amount != null && unit != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    '${_formatNumber(amount!)} $unit',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
                  ),
                ),
            ],
          ),

          if (trailing != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: FittedBox(
                // 👈 prevents overflow by scaling child
                child: trailing!,
              ),
            ),
        ],
      ),
    );
  }
}
