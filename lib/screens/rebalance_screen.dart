import 'package:flutter/material.dart';
import 'package:investment_app/models/fund.dart';
import 'package:investment_app/providers/portfolio_provider.dart';
import 'package:investment_app/theme/app_theme.dart';
import 'package:investment_app/utils/formatters.dart';
import 'package:investment_app/widgets/rebalance_actions_widget.dart';
import 'package:provider/provider.dart';

class RebalanceScreen extends StatelessWidget {
  const RebalanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('再平衡'),
      ),
      body: Consumer<PortfolioProvider>(
        builder: (context, provider, child) {
          final actions = provider.getRebalanceActions();
          final needsRebalancing = provider.needsRebalancing;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatusCard(needsRebalancing, provider),
                const SizedBox(height: 16),
                _buildCurrentAllocation(provider),
                const SizedBox(height: 16),
                _buildActionsCard(actions),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusCard(bool needsRebalancing, PortfolioProvider provider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(
              needsRebalancing ? Icons.warning : Icons.check_circle,
              color: needsRebalancing ? AppTheme.warning : Colors.green,
              size: 48,
            ),
            const SizedBox(height: 12),
            Text(
              needsRebalancing ? '需要再平衡' : '投资组合已平衡',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: needsRebalancing ? AppTheme.warning : Colors.green,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              needsRebalancing
                  ? '当前投资比例偏离目标配置，建议进行调整'
                  : '各类别比例在目标范围内，无需调整',
              style: const TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            if (needsRebalancing) ...[
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.swap_horiz),
                label: const Text('执行再平衡'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentAllocation(PortfolioProvider provider) {
    final percentages = provider.categoryPercentages;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '当前配置',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            ...PortfolioCategory.values.map((category) {
              final percentage = percentages[category] ?? 0;
              final deviation = percentage - 0.25;
              final color = AppTheme.getCategoryColor(category);
              final deviationColor = deviation > 0
                  ? Colors.red
                  : deviation < 0
                      ? Colors.blue
                      : Colors.green;
              final deviationText =
                  deviation >= 0 ? '+${(deviation * 100).toStringAsFixed(1)}%' : '${(deviation * 100).toStringAsFixed(1)}%';

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
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
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(category.displayName),
                          LinearProgressIndicator(
                            value: percentage,
                            backgroundColor: Colors.grey[200],
                            valueColor: AlwaysStoppedAnimation<Color>(color),
                            minHeight: 6,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          Formatters.formatPercent(percentage),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          deviationText,
                          style: TextStyle(
                            fontSize: 12,
                            color: deviationColor,
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

  Widget _buildActionsCard(List<dynamic> actions) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '操作建议',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            if (actions.isEmpty)
              const Center(
                heightFactor: 2,
                child: Text(
                  '无需进行再平衡操作',
                  style: TextStyle(color: Colors.grey),
                ),
              )
            else
              ...actions.map((action) {
                final rebalanceAction = action as dynamic;
                final isBuy = rebalanceAction.isBuy;
                return ListTile(
                  leading: Icon(
                    isBuy ? Icons.add_circle : Icons.remove_circle,
                    color: isBuy ? Colors.green : Colors.red,
                  ),
                  title: Text(rebalanceAction.description),
                  subtitle: Text(
                    isBuy ? '建议买入以恢复平衡' : '建议卖出以恢复平衡',
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}
