import 'package:flutter/material.dart';
import 'package:investment_app/models/fund.dart';
import 'package:investment_app/theme/app_theme.dart';
import 'package:investment_app/utils/formatters.dart';

class CategoryCard extends StatelessWidget {
  final PortfolioCategory category;
  final double currentAmount;
  final double targetAmount;
  final double currentPercentage;
  final double targetPercentage;

  const CategoryCard({
    super.key,
    required this.category,
    required this.currentAmount,
    required this.targetAmount,
    required this.currentPercentage,
    required this.targetPercentage,
  });

  @override
  Widget build(BuildContext context) {
    final color = AppTheme.getCategoryColor(category);
    final deviation = currentPercentage - targetPercentage;
    final deviationText = deviation >= 0 ? '+${(deviation * 100).toStringAsFixed(1)}%' : '${(deviation * 100).toStringAsFixed(1)}%';
    final deviationColor = deviation > 0 ? Colors.red : deviation < 0 ? Colors.blue : Colors.green;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  category.displayName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  Formatters.formatPercent(currentPercentage),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: currentPercentage,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '当前: ${Formatters.formatCurrency(currentAmount)}',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                Text(
                  '目标: ${Formatters.formatPercent(targetPercentage)}',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '偏离: ',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                Text(
                  deviationText,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: deviationColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
