import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:investment_app/models/fund.dart';
import 'package:investment_app/theme/app_theme.dart';

class PieChartWidget extends StatelessWidget {
  final Map<PortfolioCategory, double> percentages;

  const PieChartWidget({
    super.key,
    required this.percentages,
  });

  @override
  Widget build(BuildContext context) {
    final data = PortfolioCategory.values.map((category) {
      return PieChartSectionData(
        value: (percentages[category] ?? 0) * 100,
        title: '${((percentages[category] ?? 0) * 100).toStringAsFixed(0)}%',
        color: AppTheme.getCategoryColor(category),
        titleStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      );
    }).toList();

    return AspectRatio(
      aspectRatio: 1,
      child: PieChart(
        PieChartData(
          sections: data,
          centerSpaceRadius: 40,
          sectionsSpace: 2,
        ),
      ),
    );
  }
}
