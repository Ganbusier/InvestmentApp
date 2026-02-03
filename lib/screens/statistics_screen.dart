import 'package:flutter/material.dart';
import 'package:investment_app/models/fund.dart';
import 'package:investment_app/providers/portfolio_provider.dart';
import 'package:investment_app/theme/app_theme.dart';
import 'package:investment_app/utils/formatters.dart';
import 'package:investment_app/widgets/pie_chart_widget.dart';
import 'package:provider/provider.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('投资统计'),
      ),
      body: Consumer<PortfolioProvider>(
        builder: (context, provider, child) {
          final percentages = provider.categoryPercentages;
          final totalAmount = provider.totalAmount;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSummaryCard(totalAmount),
                const SizedBox(height: 16),
                _buildPieChartCard(percentages),
                const SizedBox(height: 16),
                _buildCategoryDetails(provider, percentages, totalAmount),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryCard(double totalAmount) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              '总投资金额',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              Formatters.formatCurrency(totalAmount),
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPieChartCard(Map<PortfolioCategory, double> percentages) {
    final hasData = percentages.values.any((p) => p > 0);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              '投资分布',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            hasData
                ? SizedBox(
                    height: 200,
                    child: PieChartWidget(percentages: percentages),
                  )
                : const Center(
                    heightFactor: 2,
                    child: Text(
                      '暂无投资数据',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryDetails(
    PortfolioProvider provider,
    Map<PortfolioCategory, double> percentages,
    double totalAmount,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '类别详情',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            ...PortfolioCategory.values.map((category) {
              final amount = provider.portfolio?.getAmountByCategory(category) ?? 0;
              final percentage = percentages[category] ?? 0;
              final color = AppTheme.getCategoryColor(category);

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
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
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        const Spacer(),
                        Text(
                          Formatters.formatPercent(percentage),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: percentage,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                      minHeight: 6,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          Formatters.formatCurrency(amount),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          '目标: 25%',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
