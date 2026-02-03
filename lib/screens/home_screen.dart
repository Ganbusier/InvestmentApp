import 'package:flutter/material.dart';
import 'package:investment_app/models/fund.dart';
import 'package:investment_app/models/portfolio.dart';
import 'package:investment_app/providers/portfolio_provider.dart';
import 'package:investment_app/theme/app_theme.dart';
import 'package:investment_app/utils/formatters.dart';
import 'package:investment_app/widgets/category_card.dart';
import 'package:investment_app/widgets/pie_chart_widget.dart';
import 'package:investment_app/widgets/warning_banner.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('理财App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddFundDialog(context),
          ),
        ],
      ),
      body: Consumer<PortfolioProvider>(
        builder: (context, provider, child) {
          if (!provider.isLoaded) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSummaryCard(context, provider),
                if (provider.hasWarnings)
                  WarningBanner(
                    message: '部分投资类别偏离目标配置，请关注',
                    onAction: () => _showRebalanceSheet(context),
                  ),
                _buildChartSection(provider),
                _buildCategoriesSection(context, provider),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '首页'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: '基金'),
          BottomNavigationBarItem(icon: Icon(Icons.chart_pie), label: '统计'),
          BottomNavigationBarItem(icon: Icon(Icons.swap_horiz), label: '再平衡'),
        ],
        onTap: (index) {
          switch (index) {
            case 1:
              Navigator.pushNamed(context, '/funds');
              break;
            case 2:
              Navigator.pushNamed(context, '/statistics');
              break;
            case 3:
              Navigator.pushNamed(context, '/rebalance');
              break;
          }
        },
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context, PortfolioProvider provider) {
    return Card(
      margin: const EdgeInsets.all(16),
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
              Formatters.formatCurrency(provider.totalAmount),
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _showAddFundDialog(context),
                  icon: const Icon(Icons.add),
                  label: const Text('添加基金'),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: provider.needsRebalancing
                      ? () => _showRebalanceSheet(context)
                      : null,
                  icon: const Icon(Icons.swap_horiz),
                  label: const Text('再平衡'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartSection(PortfolioProvider provider) {
    final percentages = provider.categoryPercentages;
    final hasData = percentages.values.any((p) => p > 0);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
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

  Widget _buildCategoriesSection(
      BuildContext context, PortfolioProvider provider) {
    final percentages = provider.categoryPercentages;
    final deviations = provider.categoryDeviations;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '各类别详情',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...PortfolioCategory.values.map((category) {
            final amount = provider.portfolio?.getAmountByCategory(category) ?? 0;
            final percentage = percentages[category] ?? 0;
            final target = 0.25;
            final targetAmount = provider.totalAmount * target;

            return CategoryCard(
              category: category,
              currentAmount: amount,
              targetAmount: targetAmount,
              currentPercentage: percentage,
              targetPercentage: target,
            );
          }),
        ],
      ),
    );
  }

  void _showAddFundDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('添加基金'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: '基金名称',
                  hintText: '请输入基金名称',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: '基金代码',
                  hintText: '请输入基金代码',
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<PortfolioCategory>(
                value: PortfolioCategory.stock,
                decoration: const InputDecoration(
                  labelText: '投资类别',
                ),
                items: PortfolioCategory.values.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category.displayName),
                  );
                }).toList(),
                onChanged: (value) {},
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: '投资金额',
                  hintText: '请输入投资金额',
                  prefixText: '¥ ',
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('添加'),
          ),
        ],
      ),
    );
  }

  void _showRebalanceSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '再平衡建议',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text('根据当前投资组合偏离情况，建议进行以下调整：'),
            const SizedBox(height: 16),
            const ListTile(
              leading: Icon(Icons.remove_circle, color: Colors.red),
              title: Text('卖出 股票/权益类 ¥1,000.00'),
              subtitle: Text('比例偏高，建议减少'),
            ),
            const ListTile(
              leading: Icon(Icons.add_circle, color: Colors.green),
              title: Text('买入 长期债券 ¥500.00'),
              subtitle: Text('比例偏低，建议增加'),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('取消'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('执行再平衡'),
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
