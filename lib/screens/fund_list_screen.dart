import 'package:flutter/material.dart';
import 'package:investment_app/models/fund.dart';
import 'package:investment_app/providers/portfolio_provider.dart';
import 'package:investment_app/widgets/fund_card.dart';
import 'package:provider/provider.dart';

class FundListScreen extends StatelessWidget {
  const FundListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的基金'),
      ),
      body: Consumer<PortfolioProvider>(
        builder: (context, provider, child) {
          final funds = provider.getAllFunds();

          if (funds.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.account_balance_wallet,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '暂无基金',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: () => _showAddFundDialog(context),
                    icon: const Icon(Icons.add),
                    label: const Text('添加基金'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: funds.length,
            itemBuilder: (context, index) {
              final fund = funds[index];
              return FundCard(
                fund: fund,
                onTap: () => _showEditFundDialog(context, fund),
                onDelete: () => _confirmDelete(context, fund),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddFundDialog(context),
        child: const Icon(Icons.add),
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

  void _showEditFundDialog(BuildContext context, Fund fund) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('编辑基金'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: fund.name,
                decoration: const InputDecoration(
                  labelText: '基金名称',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: fund.code,
                decoration: const InputDecoration(
                  labelText: '基金代码',
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<PortfolioCategory>(
                value: fund.category,
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
                initialValue: fund.amount.toString(),
                decoration: const InputDecoration(
                  labelText: '投资金额',
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
            child: const Text('保存'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, Fund fund) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: Text('确定要删除 ${fund.name} 吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('删除'),
          ),
        ],
      ),
    );
  }
}
