import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:permanent_portfolio/models/fund.dart';
import 'package:permanent_portfolio/theme/app_theme.dart';

class PieChartWidget extends StatelessWidget {
  final Map<PortfolioCategory, double> percentages;

  const PieChartWidget({
    super.key,
    required this.percentages,
  });

  @override
  Widget build(BuildContext context) {
    final categories =
        PortfolioCategory.values.where((c) => (percentages[c] ?? 0) > 0).toList();

    if (categories.isEmpty) {
      return const Center(
        child: Text(
          '暂无投资数据',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white54,
          ),
        ),
      );
    }

    final data = categories.map((category) {
      final percentage = (percentages[category] ?? 0) * 100;
      final color = AppTheme.getCategoryColor(category);

      return PieChartSectionData(
        value: percentage,
        color: color,
        radius: 45,
        title:
            '${category.displayName}\n${percentage.toStringAsFixed(2)}%',
        titleStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 10,
          shadows: [
            Shadow(
              color: Colors.black26,
              offset: Offset(0, 1),
              blurRadius: 2,
            ),
          ],
        ),
        showTitle: true,
        titlePositionPercentageOffset: 1.45,
      );
    }).toList();

    return SizedBox(
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          PieChart(
            PieChartData(
              sections: data,
              centerSpaceRadius: 45,
              sectionsSpace: 1,
              pieTouchData: PieTouchData(enabled: true),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '总投资',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withValues(alpha: 0.5),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                '100%',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
