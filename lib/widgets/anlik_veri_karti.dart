import 'package:flutter/material.dart';
class VeriKartiDegeriMetinOlanlar extends StatelessWidget {
  final String label;
  final String? value;
  final IconData icon;
  final Color iconColor;

  const VeriKartiDegeriMetinOlanlar(
    this.label,
    this.value,
    this.icon,
    this.iconColor, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), 
      shadowColor: iconColor.withOpacity(0.9),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, size: 40, color: iconColor),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: iconColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value ?? "Yükleniyor...",
                  style: theme.textTheme.titleMedium?.copyWith(color: Colors.grey.shade900),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


class VeriKarti extends StatelessWidget {
  final String label;
  final double? value;
  final String unit;
  final IconData icon;
  final Color iconColor;

  const VeriKarti(
    this.label,
    this.value,
    this.unit,
    this.icon,
    this.iconColor, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      shadowColor: iconColor.withOpacity(0.9),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, size: 40, color: iconColor),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: iconColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value != null ? "${value!.toStringAsFixed(1)} $unit" : "Yükleniyor...",
                  style: theme.textTheme.titleMedium?.copyWith(color: Colors.grey.shade900)
                  
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
}
